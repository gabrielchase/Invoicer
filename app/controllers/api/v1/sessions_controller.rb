class Api::V1::SessionsController < ApplicationController
  def show 
    current_user ? head(:ok) : head(:unauthorized)
  end 

  def create 
    @user = User.where(email: params[:email]).first()

    if @user&.valid_password?(params[:password])
      render(:create, status: :ok)
    else 
      head(:unauthorized)
    end
  end 

  def destroy 
    if nilify_token && current_user.save()
      head(:ok)
    else 
      head(:unauthorized)
    end 
  end

  private

  def nilify_token
    current_user&.authentication_token = nil 
  end 
end 