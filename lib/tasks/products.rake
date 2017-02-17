namespace :products do
  desc "Update specification"
  task update_spec: :environment do
    Product.all.each do |product| 
      product.update_spec
    end
  end

  desc "Update price and amazon api data"
  task update_prices: :environment do
    Product.order('amazon_api_data_updated_at ASC').limit(50).each do |product|
      old_price = product.price_in_cents
      product.update_price
      product.update_spec
      puts "#{product.id}: #{old_price} -> #{product.price_in_cents}"
    end
  end

  desc "Update amazon www data"
  task update_amazon_www_data: :environment do
    Product.order('amazon_www_data_updated_at ASC').limit(50).each do |product|
      product.update_amazon_www_data
      product.update_spec
      puts "#{product.id}: #{product.amazon_www_data}"
    end
  end

  desc "Extract products from comments"
  task extract: :environment do
    Comment.without_products.each do |comment|
      products = ProductExtractor.new(comment.body).get_products(['NOTEBOOK_COMPUTER'])
      if products.empty?
        print "."
        comment.destroy
      else
        puts products
        comment.products = products.map do |product|
          mentioned_product = Product.find_or_create_by(asin: product[:asin]) do |p|
            p.title = product[:title]
            p.offer_url = "https://www.amazon.com/dp/#{product[:asin]}"#/?tag=#{ENV['AMAZON_ASSOC_TAG']}"
            if product[:price]
              p.price_in_cents = product[:price].to_i
              p.price_updated_at = Time.now
            end

            p.amazon_api_data = product
            p.amazon_www_data = AmazonScraper.new(p.offer_url).technical_details
          end
          mentioned_product.update_spec
          mentioned_product
        end
      end
    end
  end
end
