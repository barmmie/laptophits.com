namespace :products do
  desc "Update products attributes values."
  task update_attributes: :environment do
    Product.all.each do |product|
      item = ProductExtractor.new(product.offer_url).get_products.first
      product.brand = item[:brand]
      product.save
    end
  end
end
