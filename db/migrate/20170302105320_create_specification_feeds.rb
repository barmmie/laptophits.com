class CreateSpecificationFeeds < ActiveRecord::Migration
  def change
    create_table :specification_feeds do |t|
      t.string :source
      t.string :uin
      t.jsonb :data
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
