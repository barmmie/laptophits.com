class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :author
      t.string :author_flair_css_class
      t.string :author_flair_text
      t.text :body
      t.text :body_html
      t.timestamp :created_utc
      t.string :comment_id
      t.string :link_author
      t.timestamp :link_created_utc
      t.string :link_domain
      t.string :link_id
      t.integer :link_num_comments
      t.boolean :link_over_18
      t.string :link_permalink
      t.string :link_title
      t.string :parent_id
      t.boolean :stickied
      t.string :subreddit
      t.string :subreddit_id

      t.timestamps null: false
    end
  end
end
