class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.references :product, index: true, foreign_key: true
      t.references :comment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
