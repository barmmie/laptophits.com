class AddAmazonApiDataToProduct < ActiveRecord::Migration
  def change
    add_column :products, :amazon_api_data, :jsonb
  end
end
