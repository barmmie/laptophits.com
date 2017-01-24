class AddDefaultTimeToUpdatedAtColumns < ActiveRecord::Migration
  def change
    change_column_default :products, :amazon_api_data_updated_at, Time.now
    change_column_default :products, :amazon_www_data_updated_at, Time.now
    change_column_default :products, :price_updated_at, Time.now
  end
end
