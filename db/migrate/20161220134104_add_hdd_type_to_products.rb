class AddHddTypeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :hdd_type, :string
  end
end
