module TokenGenerator
  def self.generate_token(user)
    payload = { user_id: user.id }
    secret_key = Rails.application.credentials.secret_key_base

    JWT.encode(payload, secret_key)
  end
end
