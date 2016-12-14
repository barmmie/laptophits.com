class BrandExtractor
  LAPTOP_BRANDS = [ 'Acer', 'Alienware', 'Aorus', 'Apple', 'Asus', 'Clevo', 'Computer Upgrade King', 'Dell', 'Eluktronics', 'Gigabyte', 'HP', 'Lenovo', 'Microsoft', 'MSI', 'Razer', 'Samsung', 'Toshiba']
  BRAND_ALIASES = {'Computer Upgrade King' => ['CUK']}

  attr_reader :amazon_api_data, :amazon_www_data

  def initialize(data = {})
    @amazon_api_data = data[:amazon_api_data] || {}
    @amazon_www_data = data[:amazon_www_data] || {}
  end

  def extract
    extract_from_amazon_api_data || extract_from_amazon_www_data
  end

  private

  def extract_from_text(text)
    unaliased_text = unalias(text)
    LAPTOP_BRANDS.select{|laptop_brand| unaliased_text =~ /#{laptop_brand}/i}.first
  end

  def extract_from_amazon_api_data
    extract_from_text(amazon_api_data['title'])
  end

  def extract_from_amazon_www_data
    extract_from_text(amazon_www_data['Brand Name'])
  end

  def unalias(text)
    aliased_text = text.to_s

    BRAND_ALIASES.each do |brand, aliases|
      aliases.each{|brand_alias| aliased_text.gsub!(/\b#{brand_alias}\b/i, brand)}
    end

    text
  end
end
