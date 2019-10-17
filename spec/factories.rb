require 'faker'

FactoryBot.define do
  user_password = Faker::Alphanumeric.alpha(number: 10)
  
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { user_password }
    password_confirmation { user_password }
  end

  factory :account do 
    name { Faker::Company.name }
    address { Faker::Address.full_address }
    vat_rate { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    tax_payer_id { Faker::Alphanumeric.alpha() }
    default_currency { Faker::Currency.code }
  end 

  factory :organization do 
    name { Faker::Company.name }
    address { Faker::Address.full_address }
    tax_payer_number { Faker::Alphanumeric.alpha() }
  end 

  factory :contact do 
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
  end 
end