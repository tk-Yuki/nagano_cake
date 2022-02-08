class Item < ApplicationRecord
  belongs_to :genre
  attachment :image
  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy

  # 税込価格計算
  def with_tax_price
    (price * 1.1).floor
  end

end
