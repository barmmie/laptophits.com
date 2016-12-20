class HddTypeExtractor
  attr_reader :amazon_api_data, :amazon_www_data

  def initialize(data = {})
    @amazon_api_data = data[:amazon_api_data] || {}
    @amazon_www_data = data[:amazon_www_data] || {}
  end

  def extract
    HddExtractor.new({amazon_api_data: amazon_api_data, amazon_www_data: amazon_www_data}).extract[1]
  end
end

