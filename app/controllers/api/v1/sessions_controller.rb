class Api::V1::SessionsController < ApplicationController
  def show 
    current_user ? head(:ok) : head(:unauthorized)
  end 

  def create 
    @user = User.where(email: params[:email]).first()
    
    if @user&.valid_password?(params[:password])
      @jwt = WebToken.encode(@user)

      render(:create, status: :ok)
    else 
      render(json: { error: 'invalid_credentials' }, status: :unauthorized)
    end
  end 

  def destroy 
    if nilify_token && current_user.save()
      head(:ok)
    else 
      head(:unauthorized)
    end 
  end
end 