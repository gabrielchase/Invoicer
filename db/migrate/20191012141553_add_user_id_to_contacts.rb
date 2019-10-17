class AddUserIdToContacts < ActiveRecord::Migration[5.2]
  def change
    add_reference :contacts, :user, index: true, foreign_key: true
  end
end
