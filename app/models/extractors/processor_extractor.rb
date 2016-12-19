class ProcessorExtractor
  PROCESSOR_REGEXPS = {
    'Intel Core i7' => [/(i7)/i],
    'Intel Core i5' => [/(i5)/i],
    'Intel Core i3' => [/(i3)/i],
    'Intel Xeon' => [/(xeon)/i],
    'Intel Atom' => [/(atom)/i],
    'Intel Core M' => [/(core m)/i],
    'Intel Celeron' => [/(celeron)/i],
    'Intel Pentium' => [/(pentium)/i],
    'AMD FX' => [/(amd fx)/i],
    'AMD A-series' => [/(core a\d+)/i,/(amd a\d+)/i,/(a\d+-)/i,/(amd a series)/i],
    'AMD E' => [/(amd e)/i]

  }

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
    regexp_array = PROCESSOR_REGEXPS.map{|k,v| v}.flatten

    processor_regexp = Regexp.union(regexp_array)

    processor = text.to_s.match(processor_regexp){|m| m.captures.reject(&:nil?).first}

    PROCESSOR_REGEXPS.select{|k,v| processor =~ Regexp.union(v)}.keys.first
  end

  def extract_from_amazon_api_data
    extract_from_text( ([amazon_api_data['title']] + [amazon_api_data['features']]).flatten.join('|') )
  end

  def extract_from_amazon_www_data
    extract_from_text(amazon_www_data['Processor'])
  end
end
