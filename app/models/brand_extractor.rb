class BrandExtractor
  LAPTOP_BRANDS = [ 'Acer', 'Alienware', 'Aorus', 'Asus', 'Computer Upgrade King', 'Dell', 'Eluktronics', 'Gigabyte', 'HP', 'LG', 'Lenovo', 'MSI', 'Razer', 'Toshiba']
  BRAND_ALIASES = {'Computer Upgrade King' => ['CUK']}

  attr_accessor :text
  attr_reader :unaliased_text

  def initialize(text)
    self.text = text

    @unaliased_text = text
    BRAND_ALIASES.each do |brand, aliases|
      aliases.each{|brand_alias| @unaliased_text.gsub!(/\b#{brand_alias}\b/i, brand)}
    end
  end

  def get_brand(suggested_brand)
    brands = extract_brands
    default_brand = self.class.show_brand(suggested_brand)

    brand = "Other" if brands.length == 0 && !default_brand
    brand = default_brand if brands.length == 0 && default_brand
    brand = brands.first if brands.length == 1
    brand = default_brand if brands.length > 1 && default_brand
    brand = brands.first if brands.length > 1 && !default_brand

    brand
  end

  def extract_brands
    LAPTOP_BRANDS.select{|brand| unaliased_text =~ /\b#{brand}\b/i}
  end

  def self.show_brand(name)
    LAPTOP_BRANDS.select{|brand| name =~ /#{brand}/i}.first || unalias(name)
  end

  def self.unalias(name)
    return nil if name.blank?

    BRAND_ALIASES.each do |brand, aliases|
      return brand if aliases.map(&:downcase).include? name.downcase
    end
    nil
  end
end
