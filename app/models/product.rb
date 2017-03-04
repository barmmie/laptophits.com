class Product < ActiveRecord::Base
  has_many :mentions, dependent: :destroy
  has_many :comments, through: :mentions
  has_many :specification_feeds

  def update_spec
    feeds_data = self.specification_feeds.map{|feed| ["#{feed.source}_data".to_sym, feed.data] }.to_h
    update_attributes( Specification.new(feeds_data).extract )
  end

  def update_price
    amazon_api_feed = specification_feeds.where(source: 'amazon_api').first
    amazon_api_feed.refresh
    update_attributes(price_in_cents: amazon_api_feed['data']['price'], price_updated_at: amazon_api_feed.updated_at) if amazon_api_feed['data']['price'].present?
  end

  def to_param
    "#{id} #{title}".parameterize
  end
end
