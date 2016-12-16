class AddProcessorToProducts < ActiveRecord::Migration
  def change
    add_column :products, :processor, :string
  end
end
