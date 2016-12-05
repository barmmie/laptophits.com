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

  desc "Show model info."
  task update_attributes: :environment do
    Product.all.each do |product|
      product.display_size = SpecificationExtractor.new(product.title).display_size
      product.save
      puts product.title
      puts "Display: #{product.display_size}"
      puts
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
end
