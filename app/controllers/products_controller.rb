class ProductsController < ApplicationController
  def index
    @mentions_count = Mention.count

    @products = ProductFilter.new.filter_by(filter_params)
    attr_distr = AttributesDistribution.new(@products, filter_params).calculate

    @brands = attr_distr[:brand]
    @prices = attr_distr[:price]
    @display_sizes = attr_distr[:display_size]
    @rams = attr_distr[:ram_size]
    @display_resolutions = attr_distr[:display_resolution]
    @operating_systems = attr_distr[:operating_system]
    @processors = attr_distr[:processor]

    @products = @products.paginate(page: params[:page], per_page: 25)

  end

  private 

  def filter_params
    params.slice(:after, :price_from, :price_to, :brand, :display_size_from, :display_size_to, :ram_size, :display_resolution, :operating_system, :processor)
  end
end
