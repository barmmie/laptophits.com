class HddTypeExtractor
  attr_reader :amazon_api_data, :amazon_www_data

  def initialize(data = {})
    @amazon_api_data = data[:amazon_api_data] || {}
    @amazon_www_data = data[:amazon_www_data] || {}
  end

  def extract
    hdd_types = [extract_from_amazon_api_data, extract_from_amazon_www_data]

    return 'SSD + HDD' if hdd_types.include? 'SSD + HDD'
    return hdd_types.uniq.first if hdd_types.uniq.length == 1
    return nil if !hdd_types.include?(nil) && hdd_types[0] != hdd_types[1]

    extract_from_amazon_www_data || extract_from_amazon_api_data
  end

  def extract_from_text(text)
    hybrid_regexp = /hybrid/i

    return 'Hybrid' if text =~ hybrid_regexp

    dual_regexp_array = [
      /(?:hdd|rpm|hard.disk.drive).*(?:ssd|solid.state.drive)/i,
      /(?:ssd|solid.state.drive).*(?:hdd|rpm|hard.disk.drive)/i
    ]

    dual_regexp = Regexp.union(dual_regexp_array)

    return 'SSD + HDD' if text =~ dual_regexp

    ssd_regexp_array = [
      /ssd/i,
      /solid.state/i
    ]

    ssd_regexp = Regexp.union(ssd_regexp_array)

    return 'SSD' if text =~ ssd_regexp

    emmc_regexp_array = [
      /emmc/i
    ]

    emmc_regexp = Regexp.union(emmc_regexp_array)

    return 'eMMC' if text =~ emmc_regexp

    hdd_regexp_array = [
      /hdd/i,
      /\d+ ?RPM/i,
      /mechanical_hard_drive/i,
      /hard drive/i
    ]

    hdd_regexp = Regexp.union(hdd_regexp_array)

    return 'HDD' if text =~ hdd_regexp
 
      
  end

  def extract_from_amazon_api_data
    extract_from_text( ([amazon_api_data['title']] + [amazon_api_data['features']]).flatten.join('|') )
  end

  def extract_from_amazon_www_data
    extract_from_text( amazon_www_data['Hard Drive'])
  end
end

