class Subscription < ApplicationRecord
  belongs_to :customer
  has_many :subscription_teas
  has_many :teas, through: :subscription_teas

  validates :title, presence: true
  validates :price, presence: true
  validates :status, presence: true
  validates :frequency, presence: true

  enum status: { active: 0, cancelled: 1 } 
  enum frequency: { monthly: 0, weekly: 1, biweekly: 2 } 
end
