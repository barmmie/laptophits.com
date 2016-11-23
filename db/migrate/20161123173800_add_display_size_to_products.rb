class AddDisplaySizeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :display_size, :string
  end
end
