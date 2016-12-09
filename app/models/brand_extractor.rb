class BrandExtractor
  LAPTOP_BRANDS = [ 'Acer', 'Alienware', 'Aorus', 'Apple', 'Asus', 'Computer Upgrade King', 'Dell', 'Eluktronics', 'Gigabyte', 'HP', 'LG', 'Lenovo', 'MSI', 'Razer', 'Toshiba']
  BRAND_ALIASES = {'Computer Upgrade King' => ['CUK']}

  attr_accessor :text
  attr_reader :unaliased_text

  def initialize(text)
    self.text = text

    @unaliased_text = text.to_s
    BRAND_ALIASES.each do |brand, aliases|
      aliases.each{|brand_alias| @unaliased_text.gsub!(/\b#{brand_alias}\b/i, brand)}
    end
  end

  def brands
    LAPTOP_BRANDS.select{|brand| unaliased_text =~ /\b#{brand}\b/i}
  end

  def self.unalias(name)
    return nil if name.blank?

    BRAND_ALIASES.each do |brand, aliases|
      return brand if aliases.map(&:downcase).include? name.downcase
    end
    nil
  end
end
