class ApplicationController < ActionController::Base
  include Authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :android_app?, :ios_app?

  protected

  def android_app?
    hotwire_native_app? && request.user_agent.include?("Android")
  end

  def ios_app?
    hotwire_native_app? && request.user_agent.include?("iOS")
  end
end
