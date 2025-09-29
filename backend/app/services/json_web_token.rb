require 'jwt'
SECRET_KEY = ENV['SECRET_KEY']

class JsonWebToken
  def encode_token(user_id, flag, exp = 30.minutes.from_now)
    payload = {
      user_id: user_id,
      flag: flag,
      exp: exp.to_i
    }
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    raise StandardError, 'Token Expired'
  rescue JWT::DecodeError
    raise StandardError, 'Invalid Token!'
  end
end