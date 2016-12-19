class DisplaySizeExtractor
  DISPLAY_SIZE_CLEANERS = %i(rounded_size small_size)
  attr_reader :amazon_api_data, :amazon_www_data

  def initialize(data = {})
    @amazon_api_data = data[:amazon_api_data] || {}
    @amazon_www_data = data[:amazon_www_data] || {}
  end

  def extract
    select_display_size([extract_from_amazon_www_data, extract_from_amazon_api_data])
  end

  private

  def extract_from_text(text)

    regexp_array = [
      /(\d+)"/,
      /(\d+\.?\d+)"/,
      /(\d+\.?\d+) ?-? ?in[\sc]/i,
      /(\d+\.?\d+)['"]{2}/
    ]

    display_size_regexp = Regexp.union(regexp_array)

    display_size = text.to_s.match(display_size_regexp){|m| m.captures.reject(&:nil?).first}
    display_size.to_f if display_size
  end

  def extract_from_amazon_api_data
    extract_from_text( ([amazon_api_data['title']] + [amazon_api_data['features']]).flatten.join('|') )
  end

  def extract_from_amazon_www_data
    display_size_regexp = /^(\d+\.?\d*)/
    display_size = amazon_www_data['Screen Size'].to_s.match(display_size_regexp){|m| m.captures.first}
    display_size.to_f if display_size
  end

  def select_display_size(display_sizes)
    return display_sizes.first if display_sizes.reject(&:nil?).uniq.length <= 1

    clean_display_sizes = display_sizes

    DISPLAY_SIZE_CLEANERS.each{|cleaner| clean_display_sizes = send("#{cleaner}_cleaner".to_sym, clean_display_sizes)}

    clean_display_sizes.reject(&:nil?).first
  end

  def rounded_size_cleaner(display_sizes)
    base_sizes = display_sizes.reject(&:nil?).map(&:to_i).uniq
    if base_sizes.uniq.length == 1
      display_sizes.map{|size| size == base_sizes.first ? nil : size}
    else
      display_sizes
    end
  end

  def small_size_cleaner(display_sizes)
    display_sizes.map{|size| size.to_i < 8 ? nil : size}
  end
end
