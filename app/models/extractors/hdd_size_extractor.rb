class HddSizeExtractor
  attr_reader :amazon_api_data, :amazon_www_data

  def initialize(data = {})
    @amazon_api_data = data[:amazon_api_data] || {}
    @amazon_www_data = data[:amazon_www_data] || {}
  end

  def extract
    sizes = [extract_from_amazon_api_data, extract_from_amazon_www_data].flatten

    return sizes[0] if sizes.uniq.length == 1

    return sizes.reject(&:nil?).first if sizes.reject(&:nil?).length == 1
    
    sizes.max
  end

  def extract_from_text(text)
    dual_regexp_array = [
      /(\d{3} ?GB) ?\+ ?(\d ?TB)/i,
      /(\d{3} ?GB) M\.?2 SATA SSD and (\d ?TB) HDD/i,
      /(\d{3} ?GB) ?(?:PCIe|SATA|NVMe|Pro Performance|Performance)? ?SSD ?[\+,]? ?(\d ?TB)/i,
      /(\d{3} ?GB) M\.?2 SATA ?\+ ?(\d ?TB)/i,
      /(\d{3} ?GB) M\.?2 SSD OPAL2 AND (\d ?TB)/i,
      /(\d{3} ?GB) M\.?2 PCIE (\d ?TB)/i,
      /(\d{3} ?GB) HDD (\d{3} ?GB) SSD/i,
      /(\d{3} ?GB) SSD ?\+ ?(\d{3} ?GB) HDD/i,
      /(\d{3} ?GB) HDD ?\+ ?(\d{2} ?GB) SSD/i,
      /(\d{1,3} ?GB) SSD, (\d{3} ?GB) HDD/i,
      /(\d ?TB) ?(?:Performance)? ?SSD ?\+ ?(\d ?TB)/i,
      /(\d ?TB) ?[\+,] ?(\d{3} ?GB) SSD/i,
      /(\d ?TB) ?[\+,] ?(\d{3} ?G) SSD/i,
      /(\d ?TB) HDD ?\+ ?(\d{1,3} ?GB) SSD/i,
      /(\d ?TB) ?, ?(\d{3} ?GB) NVMe SSD/i,
      /(\d ?TB) \d{4}rpm.*(\d+ ?GB) ?solid.state.drive/i
    ]

    dual_hdd_size_regexp = Regexp.union(dual_regexp_array)

    dual_hdd_size = text.to_s.match(dual_hdd_size_regexp){|m| m.captures.reject(&:nil?)}

    return dual_hdd_size.map{|size| size.gsub(/G$/i,'GB').gsub(/\s+/,'').upcase}.map{|size| hdd_to_int(size)}.inject(:+) if dual_hdd_size.present?

    regexp_array = [
      /(\d{1,4} ?(?:TB|GB)) (?:SSD|HDD|HD|NVMe|Solid State Drive|Hard Drive|eMMC|Flash Memory)/i,
      /(\d{1,4} ?(?:TB|GB)) (?:PCIe|Eluktro Pro Performance|Performance|M\.2) SSD/i,
      /(\d{1,4} ?(?:TB|GB)) \d{4} ?rpm/i,
      /(\d{2,4} ?G) (?:SSD|eMMC)/i,
      /(\d(?:\.\d)? ?TB)/i,
      /(\d{3,4} ?GB)/i
    ]

    hdd_size_regexp = Regexp.union(regexp_array)
    hdd_size = text.to_s.match(hdd_size_regexp){|m| m.captures.reject(&:nil?)}
    hdd_size.map{|size| size.gsub(/G$/i,'GB').gsub(/\s+/,'').upcase}.map{|size| hdd_to_int(size)}.inject(:+) if hdd_size

  end

  def extract_from_amazon_api_data
    extract_from_text( ([amazon_api_data['title']] + [amazon_api_data['features']]).flatten.join('|') )
  end

  def extract_from_amazon_www_data
    regexp_array = [
      /(\d+ ?(?:GB|TB))/i
    ]

    hdd_size_regexp = Regexp.union(regexp_array)
    hdd_size = amazon_www_data['Hard Drive'].to_s.match(hdd_size_regexp){|m| m.captures.reject(&:nil?)}
    hdd_size.map{|size| size.gsub(/G$/i,'GB').gsub(/\s+/,'').upcase}.map{|size| hdd_to_int(size)}.inject(:+) if hdd_size
  end

  def hdd_to_int(hdd_size)
    units = {'GB' => 1, 'TB' => 1024}
    size, unit = hdd_size.match(/(\d+\.?\d*)(.*)$/).captures
    (size.to_f * units[unit]).to_i
  end
end
