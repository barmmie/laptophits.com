class ProductExtractor
  attr_accessor :text

  def initialize(text)
    self.text = text
  end

  def get_products(product_types = nil)
    products = extract_asins.map do |asin|
      begin 
        sleep(1)
        item = Amazon::Ecs.item_lookup(asin, response_group: :Large)
        raise Amazon::RequestError, item.error if item.has_error?

        price = item.get_element('Price') || item.get_element('LowestNewPrice')
        price = price.get('Amount') if price

        json = {asin: item.get_element('Item').get('ASIN'),
                title: item.get_element('ItemAttributes').get('Title'),
                manufacturer: item.get_element('ItemAttributes').get('Manufacturer'),
                brand: BrandExtractor.new(item.get_element('ItemAttributes').get('Title')).get_brand(item.get_element('ItemAttributes').get('Brand')),
                model: item.get_element('ItemAttributes').get('Model'),
                price: price,
                product_type: item.get_element('ItemAttributes').get('ProductTypeName'),
                display_size: SpecificationExtractor.new(item.get_element('ItemAttributes').get('Title')).display_size,
                features: item.get_element('ItemAttributes').get_array('Feature')}

        json if product_types.nil? || product_types.include?(json[:product_type])
      rescue Amazon::RequestError => err
        puts err
        nil
      end

    end.reject(&:nil?)
  end

  def extract_asins
    urls = extract_urls.select { |url| /www\.amazon\.com|\/\/amazon\.com/ =~ url }
    urls.map {|url| /\/([a-zA-Z0-9]{10})(?:\/|\z)|\/([0-9]{10})(?:\/|\z)/.match url; $1}.reject(&:nil?)
  end

  def extract_urls
    URI.extract(text, /http(s)?/)
  end
end
