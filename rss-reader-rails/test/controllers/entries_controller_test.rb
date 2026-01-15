require "test_helper"

class EntriesControllerTest < ActionDispatch::IntegrationTest
  include SessionTestHelper

  test "mark_as_read sets read_at for unread entries" do
    sign_in_as(users(:one))

    entry = entries(:one)
    assert_nil entry.read_at

    patch mark_as_read_entry_path(entry, format: :turbo_stream)

    entry.reload
    assert_not_nil entry.read_at
    assert_response :success
  end

  test "mark_as_unread sets read_at to nil for read entries" do
    sign_in_as(users(:one))

    entry = entries(:one)
    entry.update!(read_at: Time.current)

    patch mark_as_unread_entry_path(entry, format: :turbo_stream)

    entry.reload
    assert_nil entry.read_at
    assert_response :success
  end
end
