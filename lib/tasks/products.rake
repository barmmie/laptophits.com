namespace :products do
  desc "Update products attributes values."
  task update_brands: :environment do
    Product.all.each do |product|
      item = ProductExtractor.new(product.offer_url).get_products.first
      if product.brand != item[:brand]
        puts "#{product.brand} => #{item[:brand]}"
        product.brand = item[:brand]
        product.save
      end
    end
  end

  desc "Update product prices"
  task update_prices: :environment do
    Product.all.each do |product| 
      item = ProductExtractor.new(product.offer_url).get_products.first
      if product.price_in_cents != item[:price] && item[:price].present?
        puts "Old price: #{product.price_in_cents.to_f/100}, New price: #{item[:price].to_f/100}, Link: #{product.offer_url}"
        product.price_in_cents = item[:price]
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
    Product.all.each do |product|
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
