class Subscription < ApplicationRecord
  belongs_to :customer
  has_many :subscription_teas
  has_many :teas, through: :subscription_teas
  
  enum status: { active: 0, cancelled: 1 } 
  enum frequency: { monthly: 0, weekly: 1, biweekly: 2 } 

  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
