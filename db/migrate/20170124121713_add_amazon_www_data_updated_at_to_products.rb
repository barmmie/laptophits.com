class AddAmazonWwwDataUpdatedAtToProducts < ActiveRecord::Migration
  def change
    add_column :products, :amazon_www_data_updated_at, :datetime
  end
end
