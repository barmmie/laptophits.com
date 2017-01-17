class ChangeDisplaySizeToFloat < ActiveRecord::Migration
  def up
    add_column :products, :new_display_size, :float

    Product.all.each do |product|
      product.display_size && product.new_display_size = product.display_size.to_f
      product.save!
    end

    remove_column :products, :display_size
    rename_column :products, :new_display_size, :display_size
  end

  def down
    add_column :products, :new_display_size, :string

    Product.all.each do |product|
      product.display_size && product.new_display_size = product.display_size.to_s
      product.save!
    end

    remove_column :products, :display_size
    rename_column :products, :new_display_size, :display_size
  end
end
