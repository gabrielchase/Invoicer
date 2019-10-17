json.data do 
  json.call(
    @user, 
    :id, :full_name, :email, 
    :confirmation_token, :confirmed_at, 
    :created_at, :updated_at
  )
end 