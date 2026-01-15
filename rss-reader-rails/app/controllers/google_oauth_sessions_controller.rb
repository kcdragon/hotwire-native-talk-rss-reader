# https://developers.google.com/identity/protocols/oauth2/javascript-implicit-flow
class GoogleOauthSessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :callback ]
  allow_unauthenticated_access

  def new
    render :new, layout: false
  end

  def create
    client_id = Rails.application.credentials.dig(:google, :client_id)
    callback_uri = callback_google_oauth_sessions_url

    platform = params[:platform] || "web"
    state = SecureRandom.hex(24) + ":" + platform
    session[:google_oauth_state] = state

    redirect_url = "https://accounts.google.com/o/oauth2/v2/auth?client_id=#{client_id}&redirect_uri=#{callback_uri}&response_type=code&scope=email profile&access_type=offline&include_granted_scopes=true&state=#{state}&prompt=consent"
    redirect_to redirect_url, allow_other_host: true
  end

  def callback
    request_state = params[:state]
    session_state = session[:google_oauth_state]
    session.delete(:google_oauth_state)
    unless request_state.present? && ActiveSupport::SecurityUtils.secure_compare(request_state, session_state)
      redirect_to welcome_path, alert: "Invalid request. Please try again."
      return
    end

    # Exchange code for tokens and decode ID token
    oauth_client = GoogleOauthClient.new
    user_info = oauth_client.authenticate(
      code: params[:code],
      redirect_uri: callback_google_oauth_sessions_url
    )

    # Create or find the user
    @user = OauthUserService.find_or_create(
      oauth_provider: :google,
      current_user: authenticated? ? current_user : nil,
      uid: user_info[:uid],
      email: user_info[:email]
    )
    unless @user.persisted?
      Rails.logger.error "Google OAuth user creation failed: #{@user.errors.full_messages}"
      redirect_to welcome_path, alert: "Unable to sign in. Please try again."
      return
    end

    platform = params[:state].split(":").last
    if platform == "native"
      token = @user.signed_id(purpose: :native_auth, expires_in: 5.minutes)
      redirect_to "untitledrssreader://auth-callback?token=#{token}&platform=#{platform}", allow_other_host: true
    else
      sign_in_and_redirect_user(@user)
    end
  rescue GoogleOauthClient::AuthenticationError => e
    Rails.logger.error "Google OAuth authentication error: #{e.message}"
    redirect_to welcome_path, alert: "Unable to sign in. Please try again."
  rescue => e
    Rails.logger.error "Google OAuth callback error: #{e.class} - #{e.message}"
    redirect_to welcome_path, alert: "Unable to sign in. Please try again."
  end

  def authenticate_by_token
    user = User.find_signed(params[:token], purpose: :native_auth)

    if user
      sign_in_and_redirect_user(user)
    else
      redirect_to welcome_path, alert: "Unable to sign in. Please try again."
    end
  end

  private

  def sign_in_and_redirect_user(user)
    start_new_session_for user
    redirect_to after_authentication_url
  end
end
