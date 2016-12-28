class HddSizeExtractor
  attr_reader :amazon_api_data, :amazon_www_data

  def initialize(data = {})
    @amazon_api_data = data[:amazon_api_data] || {}
    @amazon_www_data = data[:amazon_www_data] || {}
  end

  def extract
    extract_from_api_data
  end

  def extract_from_text(text)
    regexp_array = [
    ]

    hdd_size_regexp = Regexp.union(regexp_array)

    hdd_size = text.to_s.match(hdd_size_regexp){|m| m.captures.reject(&:nil?).first}
    hdd_size.to_i if hdd_size
  end

  def extract_from_api_data
    extract_from_text( ([amazon_api_data['title']] + [amazon_api_data['features']]).flatten.join('|') )
  end

  def extract_from_amazon_www_data
  end
end

