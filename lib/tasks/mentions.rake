namespace :mentions do
  desc "Import product mentions from Reddit comments"
  task import: :environment do
    PRODUCT_TYPES = %w(NOTEBOOK_COMPUTER)

    q = '%22amazon.com%22'

    after = 12.hours.ago.to_i
    after = Comment.order('created_utc DESC').first.created_utc.to_i if Comment.first

    limit = 500

    url = "https://api.pushshift.io/reddit/search/comment?q=#{q}&after=#{after}&limit=#{limit}"
    uri = URI(url)
    response = Net::HTTP.get(uri)

    data = JSON.parse(response)['data']
    puts "Processing #{data.length} comments"

    data.each do |comment|
      products = ProductExtractor.new(comment['body']).get_products(PRODUCT_TYPES)
      if products
        puts products
        comment['comment_id'] = comment.delete 'id'
        comment['created_utc'] = Time.at(comment['created_utc']).to_datetime

        Comment.create(comment).products = products.map do |product|
          mentioned_product = Product.find_or_create_by(asin: product[:asin]) do |p|
            p.title = product[:title]
            p.offer_url = "https://www.amazon.com/dp/#{product[:asin]}/?tag=#{ENV['AMAZON_ASSOC_TAG']}"
            p.price_in_cents = product[:price].to_i if product[:price]

            p.amazon_api_data = product
          end
          mentioned_product.update_spec
          mentioned_product
        end
      end 
    end
  end
end
