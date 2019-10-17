require 'rails_helper'

describe 'Contacts API' do 
  before(:each) do 
    @user1 = create(:user)
    @user1.confirm()
    @user1_headers = authentication_header(@user1)
    
    @user2 = create(:user)
    @user2.confirm()
    @user2_headers = authentication_header(@user2)

    
    @account1 = create(:account, owner: @user1)
    @account2 = create(:account, owner: @user2)
    
    @org1 = create(:organization, account: @account1)
    @org2 = create(:organization, account: @account1)
    @org3 = create(:organization, account: @account2)
    
    expect(User.count()).to eq(2)
    expect(Account.count()).to eq(2)
  end

  context 'using the correct user' do 
    before(:each) do 
      @contact_data = generate_contact_data()
    
      post(
        api_v1_organization_contacts_path(account_id: @account1.id, organization_id: @org1.id), 
        headers: @user1_headers, 
        params: @contact_data
      )

      # print response.body

      @contact = Contact.find(json_body_data['id'])
    end 
    
    it 'returns the correct json' do 
      expect(json_body_data['id']).to be_truthy
      expect(json_body_data['first_name']).to eq(@contact_data['first_name'])
      expect(json_body_data['last_name']).to eq(@contact_data['last_name'])
      expect(json_body_data['email']).to eq(@contact_data['email'])
      expect(json_body_data['organization']['id']).to eq(@org1.id)
      expect(json_body_data['organization']['name']).to eq(@org1.name)
    end 
    
    it 'created the contact in the database' do 
      expect(@contact.id).to be_truthy
      expect(@contact.first_name).to eq(@contact_data['first_name'])
      expect(@contact.last_name).to eq(@contact_data['last_name'])
      expect(@contact.email).to eq(@contact_data['email'])
      expect(@contact.organization.id).to eq(@org1.id)
      expect(@contact.organization.name).to eq(@org1.name)
    end 

    it "returns all accounts' contacts" do 
      create(:contact, organization: @org1)
      create(:contact, organization: @org2)
      create(:contact, organization: @org3)
      
      first_org_contacts =  Contact.where(organization_id: @org1.id).map { |contact| contact['id']}
      second_org_contacts =  Contact.where(organization_id:  @org2.id).map { |contact| contact['id']}
      first_account_contact_ids = first_org_contacts + second_org_contacts

      
      second_account_contact_ids = Contact.where(organization_id: @org3.id).map { |contact| contact['id']}
      
      expect(first_account_contact_ids.length).to eq(3)
      expect(second_account_contact_ids.length).to eq(1)
      
      get(api_v1_contacts_path(account_id: @account1.id))

      expect(json_body_data.length).to eq(3)
      
      json_body_data.each do |contact|
        expect(contact['id']).to be_truthy
        expect(first_account_contact_ids).to include(contact['id'])
        expect(second_account_contact_ids).not_to include(contact['id'])
        
        contact = Contact.find(contact['id'])
        expect(contact.organization.account.id).to eq(@account1.id)
      end 

      get(api_v1_contacts_path(account_id: @account2.id))

      expect(json_body_data.length).to eq(1)
      
      json_body_data.each do |contact|
        expect(contact['id']).to be_truthy
        expect(second_account_contact_ids).to include(contact['id'])
        expect(first_account_contact_ids).not_to include(contact['id'])
        
        contact = Contact.find(contact['id'])
        expect(contact.organization.account.id).to eq(@account2.id)
      end 
    end 
    
    it "returns all organization's accounts when organization id is present" do 
      create(:contact, organization: @org1)
      create(:contact, organization: @org1)
      create(:contact, organization: @org2)

      get(api_v1_organization_contacts_path(account_id: @account1.id, organization_id: @org1.id))
      expect(json_body_data.length).to eq(3)

      json_body_data.each do |contact| 
        expect(contact['id']).to be_truthy
        expect(contact['organization']['id']).to eq(@org1.id)
      end 

      get(api_v1_organization_contacts_path(account_id: @account1.id, organization_id: @org2.id))
      expect(json_body_data.length).to eq(1)

      json_body_data.each do |contact| 
        expect(contact['id']).to be_truthy
        expect(contact['organization']['id']).to eq(@org2.id)
      end 
    end 
  end 
end 
