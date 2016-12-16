class OperatingSystemExtractor
  OS_REGEXPS = {
    'Windows 10' => [/(windows 10)/i, /(win ?10)/i, /(w10)/i],
    'Windows 8' => [/(windows 8)/i],
    'Windows 7' => [/(windows 7)/i, /(win 7)/i],
    'Chrome OS' => [/(chromebook)/i, /(chrome)/i],
    'Mac OS X' => [/(macbook)/i]}

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
    regexp_array = OS_REGEXPS.map{|k,v| v}.flatten

    operating_system_regexp = Regexp.union(regexp_array)

    operating_system = text.to_s.match(operating_system_regexp){|m| m.captures.reject(&:nil?).first}

    OS_REGEXPS.select{|k,v| operating_system =~ Regexp.union(v)}.keys.first
  end

  def extract_from_amazon_api_data
    extract_from_text( ([amazon_api_data['title']] + [amazon_api_data['features']]).flatten.join('|') )
  end

  def extract_from_amazon_www_data
    extract_from_text(amazon_www_data['Operating System'])
  end
end
