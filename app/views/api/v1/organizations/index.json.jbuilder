json.data do 
  json.array!(@organizations) do |organization|
    json.partial!('api/v1/organizations/organization', organization: organization)
  end 
end 