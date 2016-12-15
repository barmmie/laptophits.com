class SpecificationExtractor
  SPEC_PARAMS = %i(brand ram_size display_size)# operating_system display_resolution processor_type hard_drive_size hard_drive_type laptop_weight)

  attr_reader :data_sources

  def initialize(data = [])
    @data_sources = data
  end

  def extract
    SPEC_PARAMS.map do |spec_param|
      extractor = "#{spec_param}_extractor".camelize.constantize
      [spec_param, extractor.new(data_sources).public_send(:extract)]
    end.to_h
  end

#  def extract_display_size
#    text = data_sources[:amazon_api_data]['features'].unshift(data_sources[:amazon_api_data]['title']).join(',')
#
#    re_array = [
#      /(\d+)"/,
#      /(\d+\.?\d+)"/,
#      /(\d+\.?\d+) ?-? ?in[\sc]/i,
#      /(\d+\.?\d+)['"]{2}/
#    ]
#
#    re = Regexp.union(re_array)
#
#    if match = text.match(re)
#      display_size = match.captures.reject(&:nil?).first 
#      display_size if display_size.to_f > 7
#    end
#  end
#
#  def extract_ram
#    text = data_sources[:amazon_api_data]['features'].unshift(data_sources[:amazon_api_data]['title']).join(',')
#
#    re_array = [
#      /(\d+) ?GB,? (?:LP)?DDR/i,
#      /(\d+) ?GB RAM/i,
#      /(\d+) ?GB Memory/i,
#      /RAM: ?(\d+) ?GB/i,
#      /Memory: ?(\d+) ?GB/i,
#      /(\d+) ?GB \d+ ?GB/i,
#      /(\d+) ?GB\D*DDR/i,
#      /(\d+) ?GB,? ?\d+(?:GB|TB)/i
#    ]
#
#    re = Regexp.union(re_array)
#    match = text.match(re)
#    match.captures.reject(&:nil?).first if match.present?
#  end
#
#  def extract_display_resolution
#    text = data_sources[:amazon_api_data]['features'].unshift(data_sources[:amazon_api_data]['title']).join(',')
#
#    re_array = [
#      /(\d{3,} ?x ?\d{3,})/i
#    ]
#
#    re = Regexp.union(re_array)
#    match = text.match(re)
#    match.captures.reject(&:nil?).first.downcase.gsub(/\s+/,"") if match.present?
#  end
end
