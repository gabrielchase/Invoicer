json.data do 
  json.user do 
    json.call(
      @user, :id, :email, :authentication_token
    )
  end 
end 