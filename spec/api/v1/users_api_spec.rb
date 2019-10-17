require 'rails_helper'

describe 'Users API' do 
  it 'creates a user renders correct json response and adds to the database' do 
    user_data = generate_user_data()
    
    post('/api/v1/users', params: user_data )

    expect(json_body_data['id']).to be_truthy
    expect(json_body_data['full_name']).to eq(user_data['full_name'])
    expect(json_body_data['email']).to eq(user_data['email'])
    expect(json_body_data['confirmation_token']).to be_truthy
    expect(json_body_data['confirmed_at']).to be_falsey

    user = User.find(json_body_data['id'])

    expect(user.full_name).to eq(json_body_data['full_name'])
    expect(user.email).to eq(json_body_data['email'])
  end 

  it 'confirms user' do 
    user_data = generate_user_data()
    
    post('/api/v1/users', params: user_data )

    confirmation_token = json_body_data['confirmation_token']
    
    expect(json_body_data['id']).to be_truthy
    expect(confirmation_token).to be_truthy
    expect(json_body_data['confirmed_at']).to be_falsey

    get('/api/v1/users/confirm?confirmation_token=%s' % [confirmation_token])

    expect(json_body_data['confirmed_at']).to be_truthy

    user = User.find(json_body_data['id'])

    expect(user.confirmed_at.as_json()).to eq(json_body_data['confirmed_at'])
  end 
end 
