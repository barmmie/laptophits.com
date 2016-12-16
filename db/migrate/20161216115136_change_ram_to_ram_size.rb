class ChangeRamToRamSize < ActiveRecord::Migration
  def change
    rename_column :products, :ram, :ram_size
  end
end
