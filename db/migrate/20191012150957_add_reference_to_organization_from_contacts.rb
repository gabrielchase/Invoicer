class AddReferenceToOrganizationFromContacts < ActiveRecord::Migration[5.2]
  def change
    add_reference :contacts, :organization, index: true, foreign_key: true 
    remove_reference :contacts, :user, index: true
  end
end
