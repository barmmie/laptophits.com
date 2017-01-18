module ProductsHelper
  def specification_filters(distribution, params)
    display_order = %i(price brand display_size display_resolution operating_system hdd_type hdd_size processor)
    display_order.map do |spec_param|
      SpecificationFilter.new(spec_param, distribution[spec_param], params).html
    end.join.html_safe
  end
end
