class AddHddSizeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :hdd_size, :integer
  end
end
