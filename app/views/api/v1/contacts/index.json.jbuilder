json.data do 
  json.array!(@contacts) do |contact|
    json.partial!('api/v1/contacts/contact', contact: contact)
  end 
end 