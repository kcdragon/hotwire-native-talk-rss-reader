require "application_system_test_case"

class RegistrationsTest < ApplicationSystemTestCase
  test "user can sign up" do
    visit welcome_path

    click_on "Sign up"

    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Confirm Password", with: "password123"

    click_button "Sign up"

    assert_text "There are no entries yet. Add a feed to get started."
    assert_button "Sign out"
  end
end
