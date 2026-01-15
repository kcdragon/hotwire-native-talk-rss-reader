require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "user can change their email address" do
    user = users(:one)
    sign_in(user)

    click_on "Account Settings"

    assert_text "Account Settings"
    assert_text "Change Email Address"

    within(first(".border.rounded-lg")) do
      fill_in "New Email Address", with: "newemail@example.com"
      fill_in "Current Password", with: "password"
      click_button "Update Email"
    end

    assert_text "Email address updated successfully"
    assert user.reload.email_address == "newemail@example.com"
  end

  test "user can change their password" do
    user = users(:one)
    sign_in(user)

    click_on "Account Settings"

    assert_text "Account Settings"
    assert_text "Change Password"

    within(all(".border.rounded-lg").last) do
      fill_in "Current Password", with: "password"
      fill_in "New Password", with: "newpassword123"
      fill_in "Confirm New Password", with: "newpassword123"
      click_button "Update Password"
    end

    assert_text "Password updated successfully"
    assert user.reload.authenticate("newpassword123")
  end
end
