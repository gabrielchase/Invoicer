
module WebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base
  JWT_ALGO = Rails.application.credentials.jwt_algorithm
  EXPIRY = (Time.now() + 2.weeks).to_i()

  def self.decode(token) 
    JWT.decode(
      token, 
      WebToken::SECRET_KEY, 
      true, 
      { algorithm:  WebToken::JWT_ALGO }
    )
    rescue JWT::ExpiredSignature
      :expired
  end 

  def self.encode(user)
    JWT.encode(token_params(user), WebToken::SECRET_KEY, WebToken::JWT_ALGO) 
  end

  private 

  def self.token_params(user)
    { user_id: user.id, exp: EXPIRY }
  end 
end 