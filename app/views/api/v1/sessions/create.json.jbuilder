json.data do 
  json.call(
    @user, :id, :email, :confirmation_token
  )
  json.jwt_token @jwt
end 