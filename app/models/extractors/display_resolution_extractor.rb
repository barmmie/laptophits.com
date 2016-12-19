class DisplayResolutionExtractor
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
      /(\d{3,} ?x ?\d{3,})/i,
      /(\d{3,} ?\* ?\d{3,})/i,
      /(\d{3,}-by-\d{3,})/i

    ]

    display_resolution_regexp = Regexp.union(regexp_array)

    display_resolution = text.to_s.match(display_resolution_regexp){|m| m.captures.reject(&:nil?).first}

    display_resolution  = display_resolution.downcase.gsub(/\s+/,"").gsub(/\*/,"x").gsub(/-by-/,"x") if display_resolution
  end

  def extract_from_amazon_api_data
    extract_from_text( ([amazon_api_data['title']] + [amazon_api_data['features']]).flatten.join('|') )
  end

  def extract_from_amazon_www_data
    max_display_resolution = extract_from_text(amazon_www_data['Max Screen Resolution'])
    display_resolution = extract_from_text(amazon_www_data['Screen Resolution'])

    display_resolution || max_display_resolution
  end
end
