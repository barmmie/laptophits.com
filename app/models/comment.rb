class Comment < ActiveRecord::Base
  has_many :mentions, dependent: :destroy
  has_many :products, through: :mentions

  def self.create_from_reddit reddit_comment
    create(reddit_comment.slice(*RedditComments.attributes))
  end
end
