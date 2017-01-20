class ChangeRamSizeType < ActiveRecord::Migration
  def change
    change_column :products, :ram_size, :float
  end
end
