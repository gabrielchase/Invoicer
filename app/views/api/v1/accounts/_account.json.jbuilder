json.call(account, :id, :name, :slug, :address, :tax_payer_id, :vat_rate, :default_currency)

json.owner do 
  json.call(account.owner, :id, :email, :full_name, :confirmed_at)
end 

json.call(account, :created_at, :updated_at)