class OauthUserService
  def self.find_or_create(oauth_provider:, current_user: nil, uid:, email:)
    user = User.find_by(oauth_provider: oauth_provider, oauth_uid: uid)
    return user if user

    if current_user&.guest?
      current_user.update(
        oauth_provider: oauth_provider,
        oauth_uid: uid,
        email_address: email,
        guest: false
      )
      return current_user
    end

    if email.present?
      user = User.find_by(email_address: email)
      if user
        user.update(oauth_provider: oauth_provider, oauth_uid: uid)
        return user
      end
    end

    User.create(
      oauth_provider: oauth_provider,
      oauth_uid: uid,
      email_address: email,
      guest: false
    )
  end
end
