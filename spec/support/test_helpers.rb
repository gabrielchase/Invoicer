require 'faker'
require 'json'

module TestHelpers
  def generate_user_data 
    user_password = Faker::Alphanumeric.alpha(number: 10)
    { 
      full_name:  Faker::Name.name,
      email:  Faker::Internet.email,
      password:  user_password,
      password_confirmation:  user_password,
    }.as_json()
  end

  def generate_account_data 
    {
      name: Faker::Company.name,
      address: Faker::Address.full_address,
      vat_rate: Faker::Number.decimal(l_digits: 1, r_digits: 2),
      tax_payer_id: Faker::Alphanumeric.alpha(),
      default_currency: Faker::Currency.code
    }.as_json()
  end 

  def generate_organization_data 
    { 
      name: Faker::Company.name,
      address: Faker::Address.full_address,
      tax_payer_number: Faker::Alphanumeric.alpha(),
    }.as_json()
  end 

  def generate_contact_data 
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email
    }.as_json()
  end 

  def authentication_header(user) 
    token_string = "Bearer #{WebToken.encode(user)}"
    {
      'Authorization': token_string
    }
  end

  def compare_account_attributes(expected, actual) 
    
  end

  def json_body 
    JSON.parse(response.body)
  end 

  def json_body_error
    JSON.parse(response.body)['error']
  end 

  def json_body_data 
    JSON.parse(response.body)['data']
  end 
end 
