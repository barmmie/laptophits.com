class Product < ActiveRecord::Base
  has_many :mentions, dependent: :destroy
  has_many :comments, through: :mentions
  has_many :specification_feeds

  def update_spec
    update_attributes( Specification.new({ 
      amazon_api_data: amazon_api_data,
      amazon_www_data: amazon_www_data }).extract )
  end

  def update_price
    update_amazon_api_data
    if amazon_api_data['price'].present?
      self.price_in_cents = amazon_api_data['price']
      self.price_updated_at = amazon_api_data_updated_at
      save
    end
  end

  def update_amazon_api_data
    amazon_api_data = ProductExtractor.new(offer_url).get_products.first
    self.amazon_api_data_updated_at = Time.now
    amazon_api_data.present? && self.amazon_api_data = amazon_api_data
    save
  end

  def update_amazon_www_data
    amazon_www_data = AmazonScraper.new(offer_url).technical_details
    self.amazon_www_data_updated_at = Time.now
    amazon_www_data.present? && self.amazon_www_data = amazon_www_data
    save
  end

  def to_param
    "#{id} #{title}".parameterize
  end
end
