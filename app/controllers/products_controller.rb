class ProductsController < ApplicationController
  def index
    @mentions_count = Mention.count

    @products = ProductFilter.new.filter_by(filter_params.merge(params.slice('after')))
    @attr_distr = AttributesDistribution.new(@products, filter_params).calculate

    @products = @products.paginate(page: params[:page], per_page: 25)

  end

  private 

  def filter_params
    params.slice(*Specification.filter_params.values.flatten)
  end
end
