json.data do 
  json.partial!('api/v1/organizations/organization', organization: @organization)
end 