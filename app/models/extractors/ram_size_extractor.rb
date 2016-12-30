class RamSizeExtractor
  attr_reader :amazon_api_data, :amazon_www_data

  def initialize(data = {})
    @amazon_api_data = data[:amazon_api_data] || {}
    @amazon_www_data = data[:amazon_www_data] || {}
  end

  def extract
    extract_from_amazon_www_data || extract_from_amazon_api_data
  end

  private

  def extract_from_text(text)

    regexp_array = [
      /(\d+) ?GB,? (?:LP)?DDR/i,
      /(\d+) ?GB RAM/i,
      /(\d+) ?GB Memory/i,
      /RAM: ?(\d+) ?GB/i,
      /Memory: ?(\d+) ?GB/i,
      /(\d+) ?GB \d+ ?GB/i,
      /(\d+) ?GB ?,? ?\d+(?:GB|TB)/i,
      /(\d+) ?GB ?- ?\d+(?:GB|TB)/i

    ]

    ram_size_regexp = Regexp.union(regexp_array)

    ram_size = text.to_s.match(ram_size_regexp){|m| m.captures.reject(&:nil?).first}
    ram_size.to_i if ram_size
  end

  def extract_from_amazon_api_data
    extract_from_text( ([amazon_api_data['title']] + [amazon_api_data['features']]).flatten.join('|') )
  end

  def extract_from_amazon_www_data
    ram_size_regexp = /^(\d+)/
    ram_size = amazon_www_data['RAM'].to_s.match(ram_size_regexp){|m| m.captures.first}

    if ram_size && ram_size.to_i > 0
      ram_size.to_i
    else
      nil
    end

  end
end
