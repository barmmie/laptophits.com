class Comment < ActiveRecord::Base
  has_many :mentions, dependent: :destroy
  has_many :products, through: :mentions

  def self.create_from_reddit reddit_comment
    reddit_comment['comment_id'] = reddit_comment.delete 'id'
    reddit_comment['created_utc'] = Time.at(reddit_comment['created_utc']).to_datetime
    create(reddit_comment.slice(*RedditComments.attributes))
  end

  def self.without_products
    includes(:mentions).where('mentions.id IS NULL').references(:mentions)
  end

  def self.with_products
    includes(:mentions).where('mentions.id IS NOT NULL').references(:mentions)
  end
end
