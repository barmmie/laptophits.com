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
end
