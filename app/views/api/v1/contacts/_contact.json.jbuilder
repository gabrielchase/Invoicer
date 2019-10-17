json.call(contact, :id, :first_name, :last_name, :email)

json.organization do 
  json.call(contact.organization, :id, :name, :address, :tax_payer_number)
end 

json.call(contact, :created_at, :updated_at)
