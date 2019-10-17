class Api::V1::UsersController < ApplicationController
  def index 
    @users = User.all()
    render(json: @users, status: :ok)
  end

  def create
    @user = User.new(user_params)
    
    if @user.save()
      render(:create, status: :created)
    else 
      head(:unprocessable_entity)
    end 
  end 

  def confirm_user 
    @user = User.where(confirmation_token: params[:confirmation_token]).first()

    if @user.confirm() 
      render(:confirmed)
    else
      head(:unprocessable_entity)
    end 
  end 

  private 
  
  def user_params 
    params.permit(:email, :full_name, :password, :password_confirmation)
  end 
end 