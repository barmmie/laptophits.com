class SpecificationFilter 
  attr_reader :attribute_name, :distribution, :params, :option_class

  include Rails.application.routes.url_helpers
  include ActionView::Helpers
  include ActionView::Context

  def initialize(attribute_name, distribution, params)
    @attribute_name = attribute_name
    @distribution = distribution
    @params = params
    @option_class = filter_option_class
  end

  def html
    [header, content].join.html_safe
  end

  def header
    content_tag(:h4, "#{attribute_name}".gsub('_', ' ').capitalize)
  end

  def content
    content_tag(:ul, [all_option, options].join.html_safe)
  end

  def options
    distribution.except(nil).map do |value, count|
      option_class.new(attribute_name, filter_params, value, count).html
    end.join.html_safe
  end

  def all_option
    link_to_unless(all_active?, all_text, all_href)
  end

  def all_active? 
    Specification.filter_params[attribute_name].map{|filter_param| params[filter_param]}.reject(&:nil?).empty?
  end

  def all_text
    "All #{attribute_name.to_s.gsub('_',' ').pluralize}"
  end

  def all_href
    products_path(filter_params.merge( Specification.filter_params[attribute_name].map{|filter_param| [filter_param,nil]}.to_h))
  end

  def filter_option_class
    begin
      "SpecificationFilterOptions::_#{attribute_name}_filter_option".camelize.constantize 
    rescue NameError => e
      if e.message =~ /uninitialized constant .*FilterOption/
        SpecificationFilterOptions::SpecificationFilterOption
      else
        raise e
      end
    end
  end

  def filter_params
    params.slice(*Specification.filter_params.values.flatten)
  end
end
