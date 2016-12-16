class AddOperatingSystemToProducts < ActiveRecord::Migration
  def change
    add_column :products, :operating_system, :string
  end
end
