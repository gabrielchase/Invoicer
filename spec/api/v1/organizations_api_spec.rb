require 'rails_helper'

describe 'Organizations API' do 
  before(:each) do 
    @user1 = create(:user)
    @user1.confirm()
    @user1_headers = authentication_header(@user1)
    
    @account1 = create(:account, owner: @user1)
  end

  context 'using the correct user' do 
    before(:each) do 
      @organization_data = generate_organization_data()
    
      post(
        api_v1_organizations_path(account_id: @account1.id), 
        headers: @user1_headers, 
        params: @organization_data
      )
    end 

    it "returns the correct json response" do 
      expect(json_body_data['id']).to be_truthy
      expect(json_body_data['name']).to eq(@organization_data['name'])
      expect(json_body_data['address']).to eq(@organization_data['address'])
      expect(json_body_data['tax_payer_number']).to eq(@organization_data['tax_payer_number'])
      expect(json_body_data['account']['id']).to eq(@account1['id'])
      expect(json_body_data['account']['name']).to eq(@account1['name'])
    end 

    it "is created in the database" do 
      @organization = Organization.find(json_body_data['id'])

      expect(@organization.id).to be_truthy
      expect(@organization.name).to eq(@organization_data['name'])
      expect(@organization.address).to eq(@organization_data['address'])
      expect(@organization.tax_payer_number).to eq(@organization_data['tax_payer_number'])
      expect(@organization.account.id).to eq(@account1['id'])
      expect(@organization.account.name).to eq(@account1['name'])
    end 

    it "shows all account's organizations" do 
      create(:organization, account: @account1)
      create(:organization, account: @account1)
      create(:organization, account: @account1)

      get(api_v1_organizations_path(account_id: @account1.id), headers: @user1_headers)

      expect(json_body_data.length).to eq(4)

      json_body_data.each do |organization|
        expect(organization['id']).to be_truthy
        expect(organization['account']['id']).to eq(@account1.id)
        expect(organization['account']['name']).to eq(@account1.name)
      end 
    end 

    it "shows organization" do 
      @organization = Organization.find(json_body_data['id'])
      
      get(api_v1_organization_path(account_id: @organization.account.id, id: json_body_data['id']))   
      
      expect(json_body_data['name']).to eq(@organization.name)
      expect(json_body_data['address']).to eq(@organization.address)
      expect(json_body_data['tax_payer_number']).to eq(@organization.tax_payer_number)
      expect(json_body_data['account']['id']).to eq(@organization.account.id)
      expect(json_body_data['account']['name']).to eq(@organization.account.name)
    end   
  end
end 
