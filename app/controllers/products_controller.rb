class ProductsController < ApplicationController
  def index
    @mentions_count = Mention.count

    @products = ProductFilter.new.filter_by(filter_params.merge(params.slice('after')))
    attr_distr = AttributesDistribution.new(@products, filter_params).calculate

    @brands = attr_distr[:brand]
    @prices = attr_distr[:price]
    @display_sizes = attr_distr[:display_size]
    @rams = attr_distr[:ram_size]
    @display_resolutions = attr_distr[:display_resolution]
    @operating_systems = attr_distr[:operating_system]
    @processors = attr_distr[:processor]
    @hdd_types = attr_distr[:hdd_type]
    @hdd_sizes = attr_distr[:hdd_size]

    @products = @products.paginate(page: params[:page], per_page: 25)

  end

  private 

  def filter_params
    params.slice(*AttributesDistribution.attributes_filter_params.values.flatten)
  end
end
