require "test_helper"

class OauthUserServiceTest < ActiveSupport::TestCase
  test "returns existing user when oauth_provider and oauth_uid match" do
    existing_user = User.create!(
      oauth_provider: :google,
      oauth_uid: "12345",
      email_address: "existing@example.com",
      guest: false
    )

    user = OauthUserService.find_or_create(
      oauth_provider: :google,
      current_user: nil,
      uid: "12345",
      email: "existing@example.com"
    )

    assert_equal existing_user.id, user.id
    assert_equal "google", user.oauth_provider
    assert_equal "12345", user.oauth_uid
  end

  test "upgrades guest user to oauth user when current_user is guest" do
    guest_user = User.create!(
      email_address: "guest@example.com",
      password: "password",
      guest: true
    )

    user = OauthUserService.find_or_create(
      oauth_provider: :apple,
      current_user: guest_user,
      uid: "67890",
      email: "upgraded@example.com"
    )

    assert_equal guest_user.id, user.id
    assert_equal "apple", user.oauth_provider
    assert_equal "67890", user.oauth_uid
    assert_equal "upgraded@example.com", user.email_address
    assert_not user.guest
  end

  test "does not upgrade non-guest current_user" do
    existing_user = User.create!(
      email_address: "existing@example.com",
      password: "password",
      guest: false
    )

    user = OauthUserService.find_or_create(
      oauth_provider: :google,
      current_user: existing_user,
      uid: "11111",
      email: "new@example.com"
    )

    assert_not_equal existing_user.id, user.id
    assert_equal "google", user.oauth_provider
    assert_equal "11111", user.oauth_uid
    assert_equal "new@example.com", user.email_address
  end

  test "updates existing user with oauth credentials when email matches" do
    existing_user = User.create!(
      email_address: "matching@example.com",
      password: "password",
      guest: false
    )

    user = OauthUserService.find_or_create(
      oauth_provider: :google,
      current_user: nil,
      uid: "22222",
      email: "matching@example.com"
    )

    assert_equal existing_user.id, user.id
    assert_equal "google", user.oauth_provider
    assert_equal "22222", user.oauth_uid
  end

  test "creates new user when no existing user found" do
    initial_count = User.count

    user = OauthUserService.find_or_create(
      oauth_provider: :apple,
      current_user: nil,
      uid: "33333",
      email: "newuser@example.com"
    )

    assert_equal initial_count + 1, User.count
    assert user.persisted?
    assert_equal "apple", user.oauth_provider
    assert_equal "33333", user.oauth_uid
    assert_equal "newuser@example.com", user.email_address
    assert_not user.guest
  end

  test "returns invalid user when email is blank" do
    initial_count = User.count

    user = OauthUserService.find_or_create(
      oauth_provider: :apple,
      current_user: nil,
      uid: "55555",
      email: ""
    )

    assert_equal initial_count, User.count
    assert_not user.persisted?
    assert_equal "apple", user.oauth_provider
    assert_equal "55555", user.oauth_uid
    assert user.errors.any?
  end

  test "returns same user when called multiple times with same credentials" do
    user1 = OauthUserService.find_or_create(
      oauth_provider: :google,
      current_user: nil,
      uid: "77777",
      email: "idempotent@example.com"
    )

    user2 = OauthUserService.find_or_create(
      oauth_provider: :google,
      current_user: nil,
      uid: "77777",
      email: "idempotent@example.com"
    )

    assert_equal user1.id, user2.id
  end

  test "different oauth providers with same uid creates different users" do
    google_user = OauthUserService.find_or_create(
      oauth_provider: :google,
      current_user: nil,
      uid: "88888",
      email: "google@example.com"
    )

    apple_user = OauthUserService.find_or_create(
      oauth_provider: :apple,
      current_user: nil,
      uid: "88888",
      email: "apple@example.com"
    )

    assert_not_equal google_user.id, apple_user.id
    assert_equal "google", google_user.oauth_provider
    assert_equal "apple", apple_user.oauth_provider
  end
end
