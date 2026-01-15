class AppleOauthClient
  AUTHORIZE_URL = "https://appleid.apple.com/auth/authorize"
  TOKEN_URL = "https://appleid.apple.com/auth/token"
  KEYS_URL = "https://appleid.apple.com/auth/keys"

  def authorization_url(state:, nonce:, redirect_uri:)
    query_string = {
      client_id:,
      nonce:,
      redirect_uri:,
      response_mode: "form_post",
      response_type: "code",
      scope: "email name",
      state:
    }.to_query

    "#{AUTHORIZE_URL}?#{query_string}"
  end

  def authenticate(code:, redirect_uri:, nonce:)
    tokens = exchange_code_for_tokens(code, redirect_uri)

    unless tokens && tokens["id_token"]
      raise AuthenticationError, "Failed to exchange code for tokens"
    end

    user_info = decode_id_token(tokens["id_token"])

    # Verify nonce matches to prevent replay attacks
    unless user_info["nonce"] == nonce
      raise AuthenticationError, "Nonce verification failed"
    end

    {
      uid: user_info["sub"],
      email: user_info["email"]
    }
  end

  class AuthenticationError < StandardError; end

  private

  def client_id
    Rails.application.credentials.dig(:apple, :service_identifier)
  end

  def generate_client_secret
    # Apple requires a JWT signed with your private key
    private_key = OpenSSL::PKey::EC.new(Rails.application.credentials.dig(:apple, :private_key))

    headers = {
      kid: Rails.application.credentials.dig(:apple, :key_id)
    }

    claims = {
      iss: Rails.application.credentials.dig(:apple, :team_id),
      iat: Time.now.to_i,
      exp: Time.now.to_i + 86400 * 180, # 180 days
      aud: "https://appleid.apple.com",
      sub: client_id
    }

    JWT.encode(claims, private_key, "ES256", headers)
  end

  def exchange_code_for_tokens(code, redirect_uri)
    client_secret = generate_client_secret

    response = Net::HTTP.post_form(
      URI(TOKEN_URL),
      client_id:,
      client_secret:,
      code:,
      grant_type: "authorization_code",
      redirect_uri:
    )

    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

  def decode_id_token(id_token)
    jwks = JSON.parse(Net::HTTP.get(URI(KEYS_URL)), symbolize_names: true)
    jwks_keys = jwks[:keys]
    JWT.decode(id_token, nil, true, { jwks: { keys: jwks_keys }, algorithm: "RS256" }).first
  end
end
