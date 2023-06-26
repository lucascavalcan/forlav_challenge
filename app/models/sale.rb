class Sale < ApplicationRecord
    # belongs_to :company
    validates :purchaser_name, presence: true
    validates :item_price, presence: true
    validates :purchase_count, presence: true
    validates :merchant_name, presence: true
  end
