class AddDisplayResolutionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :display_resolution, :string
  end
end
