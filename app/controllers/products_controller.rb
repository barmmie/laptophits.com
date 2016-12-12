class ProductsController < ApplicationController
  def index
    @mentions_count = Mention.count

    @products = Product.filter_by(filter_params)
    attr_distr = Product.filter_attr_distribution(filter_params)

    @brands = attr_distr[:brand]
    @prices = attr_distr[:price]
    @display_sizes = attr_distr[:display_size]
    @rams = attr_distr[:ram]
    @display_resolutions = attr_distr[:display_resolution]

    @products = @products.paginate(page: params[:page], per_page: 10)

  end

  private 

  def filter_params
    params.slice(:after, :price_from, :price_to, :brand, :display_size_from, :display_size_to, :ram, :display_resolution)
  end
end
