class AddRamToProducts < ActiveRecord::Migration
  def change
    add_column :products, :ram, :integer
  end
end
