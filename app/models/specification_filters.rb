class SpecificationFilters
  attr_reader :attribute_name, :distribution, :params

  include Rails.application.routes.url_helpers
  include ActionView::Helpers
  include ActionView::Context

  def initialize(attribute_name, distribution, params)
    @attribute_name = attribute_name
    @distribution = distribution
    @params = params
  end

  def html
    [header,content].join.html_safe
  end

  def header
    content_tag(:h4, attribute_name)
  end

  def content
    content_tag(:ul, [all_option,filter].join.html_safe)
  end

  def option(value, count)
    content_tag :li do
      link_to_unless(params[attribute_name] == value, "#{value} (#{count})",
                     products_path(filter_params.merge({attribute_name => value}))) 
    end
  end

  def all_option
    content_tag :li do
      link_to_unless(params[attribute_name].nil?,
      "All #{attribute_name.to_s.pluralize}",
      products_path(params.except(:controller, :action, :page).merge(attribute_name => nil)))
    end
  end

  def filter
    distribution.map{|value, count| option(value, count)}.join
  end

  def filter_params
    params.slice(*Specification.filter_params.values.flatten)
  end
end
