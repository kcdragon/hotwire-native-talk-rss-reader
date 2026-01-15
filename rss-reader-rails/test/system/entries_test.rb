require "application_system_test_case"

class EntriesTest < ApplicationSystemTestCase
  test "user can like an entry" do
    user = users(:one)
    entry = entries(:one)

    sign_in(user)

    click_on "Entries"

    within "##{dom_id(entry, :card)}" do
      click_button "♡"
    end

    within "##{dom_id(entry, :card)}" do
      assert_button "♥"
    end

    click_on "Liked"

    assert_text entry.title
  end
end
