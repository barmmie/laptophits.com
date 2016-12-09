class RemoveFeaturesFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :features, :text
  end
end
