# https://native.hotwired.dev/reference/navigation
class HotwireNative::ConfigurationsController < ApplicationController
  skip_before_action :require_authentication

  def android_v1
    render json: {
      settings: {},
      rules: [
        {
          patterns: [
            ".*"
          ],
          properties: {
            context: "default",
            uri: "hotwire://fragment/web",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: [
            "/new$",
            "/edit$"
          ],
          properties: {
            context: "modal",
            pull_to_refresh_enabled: false
          }
        },
        {
          patterns: [
            edit_user_path
          ],
          properties: {
            context: "default",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: [
            "#{feeds_path}$",
            "#{entries_path}$",
            edit_user_path
          ],
          properties: {
            presentation: "replace_root",
            animated: false
          }
        },
        {
          patterns: [
            new_session_path,
            new_registration_path
          ],
          properties: {
            context: "default",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: [
            welcome_path
          ],
          properties: {
            presentation: "replace_root",
            animated: false
          }
        },
        {
          patterns: [
            hotwire_native_refresh_path
          ],
          properties: {
            uri: "hotwire://fragment/refresh_app"
          }
        }
      ]
    }
  end

  def ios_v1
    render json: {
      settings: {},
      rules: [
        {
          patterns: [
            ".*"
          ],
          properties: {
            context: "default",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: [
            "/new$",
            "/edit$"
          ],
          properties: {
            context: "modal",
            pull_to_refresh_enabled: false
          }
        },
        {
          patterns: [
            edit_user_path
          ],
          properties: {
            context: "default",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: [
            "#{feeds_path}$",
            "#{entries_path}$",
            edit_user_path
          ],
          properties: {
            presentation: "replace_root",
            animated: false
          }
        },
        {
          patterns: [
            new_session_path,
            new_registration_path
          ],
          properties: {
            context: "default",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: [
            welcome_path
          ],
          properties: {
            presentation: "replace_root",
            animated: false
          }
        },
        {
          patterns: [
            hotwire_native_refresh_path
          ],
          properties: {
            presentation: "refresh",
            view_controller: "refresh_app"
          }
        }
      ]
    }
  end
end
