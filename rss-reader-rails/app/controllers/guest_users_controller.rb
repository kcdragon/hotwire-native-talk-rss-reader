class GuestUsersController < ApplicationController
  allow_unauthenticated_access only: :create
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to welcome_path, alert: "Try again later." }

  def create
    @user = User.create!(guest: true)
    start_new_session_for @user
    redirect_to after_authentication_url
  end
end
