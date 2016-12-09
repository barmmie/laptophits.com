class Specification
  SPEC_PARAMS = [:brand, :display_size]
  attr_reader :data_sources

  def initialize(data = {})
    @data_sources = {title: data[:title], amazon_api_data: data[:amazon_api_data]}.reject{|k,v| v.nil?}
  end

  def extract
    {brand: extract_brand,
     display_size: extract_display_size}
  end

  def extract_brand
    extracted_brands = data_sources.keys.map{|key| public_send "extract_brand_from_#{key}"}.sum
    extracted_brands.group_by(&:itself).map{|e| [e.first, e.second.length]}.sort_by{|k,v| v}.reverse.to_h.keys.first
  end

  def extract_brand_from_title
    BrandExtractor.new(data_sources[:title]).brands
  end

  def extract_brand_from_amazon_api_data
    BrandExtractor.new(data_sources[:amazon_api_data]['brand']).brands
  end

  def extract_display_size
    extract_display_size_from_title || extract_display_size_from_amazon_api_data
  end

  def extract_display_size_from_title
    if match = data_sources[:title].match(/\b(\d{2}\.\d)(?:\b|in)|\b(\d{2})(?:"|[-]in)|\b(\d{2})[ -]Inch|\D(\d{2}\.\d)"/i)
      match.captures.reject(&:nil?).first
    end
  end

  def extract_display_size_from_amazon_api_data
    if match = data_sources[:amazon_api_data]['features'].join(' ').match(/\b(\d{2}\.\d)(?:\b|in)|\b(\d{2})(?:"|[-]in)|\b(\d{2})[ -]Inch|\D(\d{2}\.\d)"/i)
      match.captures.reject(&:nil?).first
    end
  end
end
