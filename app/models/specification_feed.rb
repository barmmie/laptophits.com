class SpecificationFeed < ActiveRecord::Base
  belongs_to :product

  validates :source, uniqueness: { scope: :product }

  def refresh
    touch

    case source
    when 'amazon_api'
      data = ProductExtractor.new("https://www.amazon.com/dp/#{uin}").get_products.first
    when 'amazon_www'
      data = AmazonScraper.new("https://www.amazon.com/dp/#{uin}").technical_details
    end

    update_attributes(data: data) if data.present?

    self
  end
end
