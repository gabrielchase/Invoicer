class Api::V1::AccountsController < ApplicationController
  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found

  def index 
    @accounts = current_user.accounts 

    render(:index, status: :ok)
  end 
  
  def create 
    @account = current_user.accounts.build(account_params)

    if @account.save()
      render(:account, status: :created)
    else
      head(:unprocessable_entity)
    end 
  end 

  def update 
    @account = current_user.accounts.friendly.find(params[:id])

    if @account.update(account_params)
      render(:account)
    else 
      head(:unprocessable_entity)
    end 
  end 

  def record_not_found(exception)
    render(json: { error: exception.message }.to_json, status: :not_found)
    return
  end    

  private 

  def account_params 
    params.permit(:name, :address, :vat_rate, :tax_payer_id, :default_currency)
  end 

end 
