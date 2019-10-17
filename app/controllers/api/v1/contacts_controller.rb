class Api::V1::ContactsController < ApplicationController
  # before_action :show_current_user 
  
  def index 
    @contacts = current_scope.contacts

    render(:index, status: :ok)
  end 

  def create 
    @contact = current_organization.contacts.build(contact_params)
    
    if @contact.save()
      render(:create, status: :created)
    else
      head(:unprocessable_entity)
    end
  end 

  def update 
    @contact = current_organization.contacts.find(params[:id])

    if @contact.update(contact_params)
      render(:update, status: :ok)
    else
      head(:unprocessable_entity)
    end
  end   

  def destroy
    @contact = current_organization.contacts.find(params[:id])

    if @contact.destroy()
      head(:ok)
    else 
      head(:unprocessable_entity)
    end 
  end 

  private 

  def current_scope 
    params[:organization_id].present? ? current_organization : current_account
  end 

  def contact_params 
    params.permit(:first_name, :last_name, :email)
  end 

  def current_organization 
    @current_organization ||= current_account.organizations.friendly.find(params[:organization_id])
  end 
end
