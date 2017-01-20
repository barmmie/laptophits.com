module ProductsHelper
  def specification_filters(distribution, params)
    %i(price brand display_size display_resolution ram_size hdd_type hdd_size processor operating_system ).map do |spec_param|
      SpecificationFilter.new(spec_param, distribution[spec_param], params).html
    end.join.html_safe
  end
end
