class Organization < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged
  
  has_many :contacts
  belongs_to :account

  validates :name, :address, :tax_payer_number, presence: true
end
