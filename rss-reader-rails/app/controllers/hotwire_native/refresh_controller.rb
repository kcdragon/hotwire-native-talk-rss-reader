class HotwireNative::RefreshController < ApplicationController
  skip_before_action :require_authentication

  def show
    render html: "Redirecting..."
  end
end
