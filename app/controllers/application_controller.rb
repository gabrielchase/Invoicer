class ApplicationController < ActionController::API
  def current_account
    @current_account ||= Account.find(params[:account_id])
  end 
end
