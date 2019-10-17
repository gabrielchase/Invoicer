class Account < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged
  
  belongs_to :owner, class_name: 'User'

  has_many :organizations 
  has_many :contacts, through: :organizations 
end
