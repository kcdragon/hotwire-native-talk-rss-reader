class WelcomeController < ApplicationController
  allow_unauthenticated_access only: :show

  def show
    redirect_to root_path if authenticated?
  end
end
