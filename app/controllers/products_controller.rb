class ProductsController < ApplicationController
  def index
    @mentions = Mention.order('created_at desc')
    @last_mention = @mentions.first

    @products = Product.joins(:comments).select('products.*, count(mentions.product_id) as "product_count"').group('products.id').order('product_count DESC')

    if params[:after]
      time_after = Time.now - ::TimeAbbr.to_time(params[:after])
      @products = @products.where('comments.created_utc > ?',time_after)
      @mentions = @mentions.joins(:comment).where('comments.created_utc > ?', time_after)
    end

    if params[:price_from]
      @products = @products.where('price_in_cents >= ?', params[:price_from].to_f*100)
      @mentions = @mentions.joins(:product).where('products.price_in_cents >= ?', params[:price_from].to_f*100)
    end

    if params[:price_to]
      @products = @products.where('price_in_cents < ?', params[:price_to].to_f*100)
      @mentions = @mentions.joins(:product).where('products.price_in_cents < ?', params[:price_to].to_f*100)
    end

    @products = @products.paginate(page: params[:page], per_page: 10)
  end
end
