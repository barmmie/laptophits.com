class ProductsController < ApplicationController
  def index
    @mentions = Mention.order('created_at desc')
    @last_mention = @mentions.first

    @products = Product.joins(:mentions).select('products.*, count(mentions.product_id) as "product_count"').group('products.id').order('product_count DESC')
  end
end
