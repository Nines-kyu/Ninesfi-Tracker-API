class Expense < ApplicationRecord
  belongs_to :category

  validates :title, presence: true, length: { maximum: 100 }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
end