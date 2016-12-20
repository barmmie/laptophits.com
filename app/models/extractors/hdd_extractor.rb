class HddExtractor
  HDD_CLEANERS = %i(combine_results hybrid_first)
  attr_reader :amazon_api_data, :amazon_www_data

  def initialize(data = {})
    @amazon_api_data = data[:amazon_api_data] || {}
    @amazon_www_data = data[:amazon_www_data] || {}
  end

  def extract
    extracted_data = [extract_from_amazon_api_data, extract_from_amazon_www_data]
    results = HDD_CLEANERS.map do |cleaner|
      send("#{cleaner}_cleaner".to_sym, extracted_data)
    end

    result = results[0].zip(results[1]).map do |x,y|
      x || y
    end

    result
  end

  def combine_results_cleaner(drives)
    drives[0].zip(drives[1]).map { |x, y| [x || y] == [x, y].uniq.compact ? (x || y) : nil }
  end

  def hybrid_first_cleaner(drives)
    hybrid_drive = drives.select{|drive| drive[1] == 'Hybrid'}.first
    hybrid_drive.present? ? hybrid_drive : [nil, nil]
  end

  def extract_from_text(text)
    hybrid_regexp =  /(\d+ ?(?:GB|TB))[a-zA-Z ]*(?:SSD|HDD|M\.2 SATA)? ?\+ ?(\d+ ?(?:GB|TB))/i
    hybrid_sizes = text.to_s.match(hybrid_regexp){|m| m.captures}

    return [ hybrid_sizes.map{|size| convert_to_gb(size)}.sum, 'Hybrid' ] if hybrid_sizes

    ssd_regexp_array = [
      /(\d+ ?(?:GB|TB))[a-zA-Z ]*(?:M\.2)? ?(?:SSD|Solid State Drive)/i
    ]

    ssd_regexp = Regexp.union(ssd_regexp_array)
    ssd_size = text.to_s.match(ssd_regexp){|m| m.captures.reject(&:nil?).first}

    return [ convert_to_gb(ssd_size), 'SSD'] if ssd_size

    emmc_regexp_array = [
      /(\d+ ?GB) eMMC/i
    ]

    emmc_regexp = Regexp.union(emmc_regexp_array)
    emmc_size = text.to_s.match(emmc_regexp){|m| m.captures.reject(&:nil?).first}

    return [ convert_to_gb(emmc_size), 'eMMC'] if emmc_size

    hdd_regexp_array = [
      /(\d+ ?(?:GB|TB)) (?:HDD|Hard Drive|HD|M\.2 SATA|SATA)/i,
      /(\d+ ?(?:GB|TB)) \d+RPM/i,
      /\d{1,2} ?GB ?(?:RAM|Memory|[A-Z]*DDR\d[A-Z]*|DDR3 RAM)? ?,? ?(\d+ ?(?:GB|TB))/i
    ]

    hdd_regexp = Regexp.union(hdd_regexp_array)
    hdd_size = text.to_s.match(hdd_regexp){|m| m.captures.reject(&:nil?).first}

    return [convert_to_gb(hdd_size), 'HDD'] if hdd_size
    
    [nil, nil]
  end

  def extract_from_amazon_api_data
    extract_from_text( ([amazon_api_data['title']] + [amazon_api_data['features']]).flatten.join('|') )
  end

  def extract_from_amazon_www_data
    text = amazon_www_data['Hard Drive']

    ssd_regexp_array = [
      /(\d+ ?(?:GB|TB))?.*(?:SSD|solid.state)/i
    ]

    ssd_size = text.to_s.match(Regexp.union(ssd_regexp_array)){|m| m.captures}
    return [convert_to_gb(ssd_size.first), 'SSD'] if ssd_size

    hybrid_regexp_array = [
      /(\d+ ?(?:GB|TB))? ?(?:hybrid)/i
    ]

    hybrid_size = text.to_s.match(Regexp.union(hybrid_regexp_array)){|m| m.captures}
    return [convert_to_gb(hybrid_size.first), 'Hybrid'] if hybrid_size

    emmc_regexp_array = [
      /(\d+ ?(?:GB|TB))? ?(?:emmc)/i
    ]

    emmc_size = text.to_s.match(Regexp.union(emmc_regexp_array)){|m| m.captures}
    return [convert_to_gb(emmc_size.first), 'eMMC'] if emmc_size

    hdd_regexp_array = [
      /(\d+ ?(?:GB|TB))? ?(?:mechanical_hard_drive|HDD|SATA)/i
    ]

    hdd_size = text.to_s.match(Regexp.union(hdd_regexp_array)){|m| m.captures}

    return [convert_to_gb(hdd_size.first), 'HDD'] if hdd_size

    no_type_regexp_array = [
      /(\d+ ?(?:GB|TB))/i
    ]

    no_type_size = text.to_s.match(Regexp.union(no_type_regexp_array)){|m| m.captures}

    return [convert_to_gb(no_type_size.first), nil] if no_type_size

    [nil,nil]
  end

  def convert_to_gb(size)
    return nil unless size 
    if size =~ /TB/i
      size.to_i * 1024
    else
      size.to_i
    end
  end
end

