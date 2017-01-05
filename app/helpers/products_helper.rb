module ProductsHelper
  def filter(attribute_name, distribution, params)
    list = distribution.map do |value, count|
      "<li>" + 
        link_to_unless(params[attribute_name] == value,
        "#{value} (#{count})",
        products_path(params.except(:controller, :action, :page).merge({attribute_name => value}))) +
      "</li>"
    end.join
    
    list = "<li>" + 
      link_to_unless(params[attribute_name].nil?,
      "All #{attribute_name.to_s.pluralize}",
      products_path(params.except(:controller, :action, :page).merge(attribute_name => nil))) + 
      "</li>" + list

    "<ul>#{list}</ul>".html_safe
  end

  def display_size_filter(display_sizes, params)
    list = display_sizes.except(0).map do |display_size, count| 
      "<li>" + 
        link_to_unless(
          params[:display_size_from].to_i == display_size && params[:display_size_to].to_i == display_size + 1,
          "#{display_size}\" - #{display_size}.9\" (#{count})",
          products_path(params.except(:controller, :action, :page).merge({display_size_from: display_size, display_size_to: display_size + 1}))) +
      "</li>"
    end.join

    list = "<li>" + 
      link_to_unless(params[:display_size_from].nil? && params[:display_size_to].nil?,
                     "All display sizes",
                     products_path(params.except(:controller, :action, :page).merge(display_size_from: nil, display_size_to: nil))) + 
      "</li>" + list

    "<ul>#{list}</ul>".html_safe
  end

  def ram_filter(rams, params)
    list = rams.map do |ram, count|
      "<li>" + 
        link_to_unless(
          params[:ram_size].to_i == ram,
          "#{ram} GB (#{count})",
          products_path(params.except(:controller, :action, :page).merge({ram_size: ram}))) +
      "</li>"
    end.join

    list = "<li>" + 
      link_to_unless(
        params[:ram_size].nil?,
        "All RAM sizes",
        products_path(params.except(:controller, :action, :page).merge(ram_size: nil))) +
      "</li>" + list

    "<ul>#{list}</ul>".html_safe
  end
end
