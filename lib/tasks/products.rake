namespace :products do
  desc "Update specification"
  task update_spec: :environment do
    Product.all.each do |product| 
      product.update_spec
    end
  end

  desc "Update price and amazon api data"
  task update_prices: :environment do
    SpecificationFeed.where(source: 'amazon_api').order('updated_at ASC').limit(50).each do |feed|
      feed.product.update_price
      feed.product.update_spec
    end
  end

  desc "Update amazon www data"
  task update_amazon_www_data: :environment do
    SpecificationFeed.where(source: 'amazon_www').order('updated_at ASC').limit(50).each do |feed|
      feed.refresh
      feed.product.update_spec
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
          end
          

          mentioned_product.specification_feeds.create([
            { source: 'amazon_www', uin: mentioned_product.asin, data: AmazonScraper.new(mentioned_product.offer_url).technical_details },
            { source: 'amazon_api', uin: mentioned_product.asin, data: product }
          ])

          mentioned_product.update_spec
          mentioned_product
        end
      end
    end
  end

  desc "Populate specification feeds"
  task populate_feeds: :environment do
    Product.all.each do |product|
      product.specification_feeds.create([
        { source: 'amazon_www', uin: product.asin, data: product.amazon_www_data },
        { source: 'amazon_api', uin: product.asin, data: product.amazon_api_data }
      ])
    end
  end
end
