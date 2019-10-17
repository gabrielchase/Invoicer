require 'rails_helper'

describe 'Accounts API' do 
  before(:each) do 
    user_data_1 = generate_user_data()
    post('/api/v1/users', params: user_data_1 )
    expect(json_body_data['id']).to be_truthy

    @user1 = User.find(json_body_data['id'])
    @user1_headers = authentication_header(@user1)

    user_data_2 = generate_user_data()
    post('/api/v1/users', params: user_data_2 )
    expect(json_body_data['id']).to be_truthy

    @user2 = User.find(json_body_data['id'])
    @user2_headers = authentication_header(@user2)
  end

  context 'unconfirmed' do 
    it 'should return an unconfirmed error' do 
      account_data = generate_account_data()

      post('/api/v1/accounts', headers: @user1_headers, params: account_data)

      expect(json_body_error).to eq('You have to confirm your email address before continuing.')
    end 
  end 

  context 'when using the correct user' do 
    before(:each) do 
      @user1.confirm()
      
      @account_data = generate_account_data()
      
      post('/api/v1/accounts', headers: @user1_headers, params: @account_data)
      
      @account = Account.find(json_body_data['id'])
    end 

    it 'creating an account returns the correct json' do 
      expect(json_body_data['id']).to be_truthy
      expect(json_body_data['slug']).to be_truthy

      expect(json_body_data['name']).to eq(@account_data['name'])
      expect(json_body_data['address']).to eq(@account_data['address'])
      expect(json_body_data['tax_payer_id']).to eq(@account_data['tax_payer_id'])
      expect(json_body_data['vat_rate']).to eq(@account_data['vat_rate'])
      expect(json_body_data['default_currency']).to eq(@account_data['default_currency'])
      
      expect(json_body_data['owner']['id']).to eq(@user1.id)
      expect(json_body_data['owner']['email']).to eq(@user1.email)
      expect(json_body_data['owner']['full_name']).to eq(@user1.full_name)
    end 

    it 'creates the account in the database' do 
      expect(@account.name).to eq(@account_data['name'])
      expect(@account.address).to eq(@account_data['address'])
      expect(@account.tax_payer_id).to eq(@account_data['tax_payer_id'])
      expect(@account.vat_rate).to eq(@account_data['vat_rate'])
      expect(@account.default_currency).to eq(@account_data['default_currency'])
      expect(@account.owner['id']).to eq(@user1.id)
    end 

    it 'returns all the user accounts' do  
      get(api_v1_accounts_path, headers: @user1_headers)

      expect(json_body_data.length).to eq(1)

      json_body_data.each do |account| 
        expect(account['id']).to be_truthy
        expect(account['owner']['id']).to eq(@user1.id)
      end 
    end 

    it 'returns the correct json when account is updated' do 
      @update_account_data = generate_account_data()
      
      put('/api/v1/accounts/%s' % [@account.id], headers: @user1_headers, params: @update_account_data)

      expect(json_body_data['name']).to eq(@update_account_data['name'])
      expect(json_body_data['address']).to eq(@update_account_data['address'])
      expect(json_body_data['tax_payer_id']).to eq(@update_account_data['tax_payer_id'])
      expect(json_body_data['vat_rate']).to eq(@update_account_data['vat_rate'])
      expect(json_body_data['default_currency']).to eq(@update_account_data['default_currency'])
    end 

    it 'changes the account data in the database' do 
      update_account_data = generate_account_data()
      
      put('/api/v1/accounts/%s' % [@account.id], headers: @user1_headers, params: update_account_data)

      updated_account = Account.find(@account.id)

      expect(updated_account.name).to eq(update_account_data['name'])
      expect(updated_account.address).to eq(update_account_data['address'])
      expect(updated_account.tax_payer_id).to eq(update_account_data['tax_payer_id'])
      expect(updated_account.vat_rate).to eq(update_account_data['vat_rate'])
      expect(updated_account.default_currency).to eq(update_account_data['default_currency'])
    end 
  end 

  context 'when using the wrong user' do 
    before(:each) do 
      @user1.confirm()
      @user2.confirm()
      
      @account_data = generate_account_data()
      
      post('/api/v1/accounts', headers: @user1_headers, params: @account_data)
      
      @account = Account.find(json_body_data['id'])
    end 
    
    it 'does not allow account update' do 
      update_account_data = generate_account_data()
      
      put('/api/v1/accounts/%s' % [@account.id], headers: @user2_headers, params: update_account_data)

      expect(json_body_error).to be_truthy
      expect(response.status).to eq(404)
    end 
  end 
end 
