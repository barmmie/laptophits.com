class ProductsController < ApplicationController
  def index
    @mentions_count = Mention.count

    @products = Product.filter_by(filter_params).paginate(page: params[:page], per_page: 10)

    @brands = @products.map(&:brand).uniq.map{|brand| [brand,0]}.to_h

  end

  private 

  def filter_params
    params.slice(:after, :price_from, :price_to, :brand)
  end
end
