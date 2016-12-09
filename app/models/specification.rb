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
    extracted_brands = BrandExtractor.new([data_sources[:amazon_api_data]['brand'].to_s, data_sources[:amazon_api_data]['title']].join(' ')).brands
    extracted_brands.group_by(&:itself).map{|e| [e.first, e.second.length]}.sort_by{|k,v| v}.reverse.to_h.keys.first || 'Other'
  end

  def extract_display_size
    text = data_sources[:amazon_api_data]['features'].unshift(data_sources[:amazon_api_data]['title']).join(',')

    re_array = [
      /(\d+\.?\d+)"/,
      /(\d+\.?\d+) ?-? ?in[\sc]/i,
      /(\d+\.?\d+)['"]{2}/
    ]

    re = Regexp.union(re_array)

    if match = text.match(re)
      display_size = match.captures.reject(&:nil?).first 
      display_size if display_size.to_f > 7
    end
  end
end
