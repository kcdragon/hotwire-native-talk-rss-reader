require "application_system_test_case"

class GuestUsersTest < ApplicationSystemTestCase
  test "user can continue as guest" do
    visit welcome_path

    click_button "Continue as Guest"

    assert_current_path entries_path
    assert_text "Feeds"
    assert_link "Create Account"
  end

  test "guest user can upgrade to full account" do
    visit welcome_path
    click_button "Continue as Guest"

    assert_text "You're using a guest account"

    click_on "Create Account"

    assert_text "Create Your Account"

    fill_in "Email", with: "upgraded@example.com"
    fill_in "Password", with: "password123"
    fill_in "Confirm Password", with: "password123"

    click_button "Create Account"

    assert_current_path root_path
    assert_no_text "You're using a guest account"
    assert_text "There are no entries yet. Add a feed to get started."
  end
end
