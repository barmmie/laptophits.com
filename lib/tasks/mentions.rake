namespace :mentions do
  desc "Import product mentions from Reddit comments"
  task import: :environment do

    data = RedditComments.latest
    
    puts "Processing #{data.length} comments"

    data.each do |comment|
      products = ProductExtractor.new(comment['body']).get_products(['NOTEBOOK_COMPUTER'])
      if products
        puts products
        comment['comment_id'] = comment.delete 'id'
        comment['created_utc'] = Time.at(comment['created_utc']).to_datetime

        Comment.create_from_reddit(comment).products = products.map do |product|
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
