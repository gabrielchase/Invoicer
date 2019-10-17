class Api::V1::OrganizationsController < ApplicationController
  def create
    @organization = current_account.organizations.build(organization_params)

    if @organization.save()
      render(:organization, status: :created)
    else 
      render(json: { errors: @organization.errors.messages }, status: :unprocessable_entity)
    end 
  end 

  def index 
    @organizations = current_account.organizations 

    render(:index, status: :ok)
  end 

  def show 
    @organization = current_account.organizations.find(params[:id])

    render(:organization, status: :ok)
  end 

  private 

  def organization_params
    params.permit(:name, :address, :tax_payer_number)
  end
end 