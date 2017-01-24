class AddAmazonApiDataUpdatedAtToProducts < ActiveRecord::Migration
  def change
    add_column :products, :amazon_api_data_updated_at, :datetime
  end
end
