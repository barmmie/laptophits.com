class AddAmazonWwwDataToProducts < ActiveRecord::Migration
  def change
    add_column :products, :amazon_www_data, :jsonb
  end
end
