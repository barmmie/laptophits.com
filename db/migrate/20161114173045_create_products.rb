class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string :offer_url
      t.integer :price_in_cents
      t.string :asin

      t.timestamps null: false
    end
  end
end
