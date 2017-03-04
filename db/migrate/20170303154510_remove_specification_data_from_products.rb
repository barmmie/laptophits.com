class RemoveSpecificationDataFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :amazon_www_data, :jsonb
    remove_column :products, :amazon_api_data, :jsonb
    remove_column :products, :amazon_www_data_updated_at, :datetime
    remove_column :products, :amazon_api_data_updated_at, :datetime
  end
end
