namespace :products do
  desc "Update product prices"
  task update_prices: :environment do
    Product.all.each do |product| 
      item = ProductExtractor.new(product.offer_url).get_products.first
      if item[:price].present?
        product.price_updated_at = Time.now
        if product.price_in_cents != item[:price] 
          puts "Old price: #{product.price_in_cents.to_f/100}, New price: #{item[:price].to_f/100}, Link: #{product.offer_url}"
          product.price_in_cents = item[:price]
        end
        product.save
      end
    end
  end

  desc "Update amazon api data"
  task update_amazon_api_data: :environment do
    Product.all.each do |product|
      product.amazon_api_data = ProductExtractor.new(product.offer_url).get_products.first
      product.save

      puts product.amazon_api_data['title']
    end
  end

  desc "Update amazon www data"
  task update_amazon_www_data: :environment do
    Product.where("amazon_www_data = '{}'").each do |product|
      product.amazon_www_data = AmazonScraper.new(product.offer_url).technical_details
      product.save

      puts product.amazon_api_data['title']
    end
  end

  desc "Update specification"
  task update_spec: :environment do
    Product.all.each do |product| 
      product.update_spec
    end
  end
end
