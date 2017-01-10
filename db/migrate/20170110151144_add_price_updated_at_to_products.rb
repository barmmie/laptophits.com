class AddPriceUpdatedAtToProducts < ActiveRecord::Migration
  def change
    add_column :products, :price_updated_at, :datetime
  end
end
