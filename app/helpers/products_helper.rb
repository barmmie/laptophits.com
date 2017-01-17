module ProductsHelper
  def specification_filters(distribution, params)
    specification_filters = %i(price brand display_size operating_system)
    specification_filters.map do |spec_param|
      SpecificationFilter.new(spec_param, distribution[spec_param], params).html
    end.join.html_safe
  end
end
