require "test_helper"

# https://justin.searls.co/posts/running-rails-system-tests-with-playwright-instead-of-selenium/
Capybara.register_driver :my_playwright do |app|
  Capybara::Playwright::Driver.new(
    app,
    browser_type: ENV["PLAYWRIGHT_BROWSER"]&.to_sym || :chromium,
    # headless: (false unless ENV["CI"] || ENV["PLAYWRIGHT_HEADLESS"]),
    headless: true,
    slowMo: 50,
  )
end

Capybara.default_max_wait_time = 5
Capybara.default_driver = :my_playwright
Capybara.javascript_driver = :my_playwright

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :my_playwright

  def sign_in(user)
    visit welcome_path
    click_on "Sign in", match: :first
    fill_in "Email", with: user.email_address
    fill_in "Password", with: "password"
    click_button "Sign in"
  end
end
