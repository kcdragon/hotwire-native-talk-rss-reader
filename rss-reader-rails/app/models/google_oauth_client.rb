class GoogleOauthClient
  TOKEN_URL = "https://oauth2.googleapis.com/token"
  KEYS_URL = "https://www.googleapis.com/oauth2/v3/certs"

  def authenticate(code:, redirect_uri:)
    tokens = exchange_code_for_tokens(code, redirect_uri)
    raise AuthenticationError, "Failed to exchange code for tokens" unless tokens && tokens["id_token"]

    user_info = decode_id_token(tokens["id_token"])
    raise AuthenticationError, "Email not verified" unless user_info["email_verified"] == true

    {
      uid: user_info["sub"],
      email: user_info["email"]
    }
  end

  class AuthenticationError < StandardError; end

  private

  def client_id
    Rails.application.credentials.dig(:google, :client_id)
  end

  def client_secret
    Rails.application.credentials.dig(:google, :client_secret)
  end

  def exchange_code_for_tokens(code, redirect_uri)
    response = Net::HTTP.post_form(
      URI(TOKEN_URL),
      client_id: client_id,
      client_secret: client_secret,
      code: code,
      grant_type: "authorization_code",
      redirect_uri: redirect_uri
    )

    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

  def decode_id_token(id_token)
    jwks = JSON.parse(Net::HTTP.get(URI(KEYS_URL)), symbolize_names: true)
    JWT.decode(id_token, nil, true, {
      jwks: { keys: jwks[:keys] },
      algorithm: "RS256",
      verify_iss: true,
      iss: [ "https://accounts.google.com", "accounts.google.com" ],
      verify_aud: true,
      aud: client_id
    }).first
  end
end
