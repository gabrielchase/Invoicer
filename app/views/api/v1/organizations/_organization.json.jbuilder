json.call(organization, :id, :name, :address, :tax_payer_number)

json.account do 
  json.call(organization.account, :id, :name, :address, :vat_rate, :tax_payer_id, :default_currency)
end 

json.call(organization, :created_at, :updated_at)
