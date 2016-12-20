module ProductsHelper
  def brand_filter(brands, params)
    list = brands.map do |brand, count|
      "<li>" + 
        link_to_unless(params[:brand] == brand,
        "#{brand} (#{count})",
        products_path(params.except(:controller, :action, :page).merge({brand: brand}))) +
      "</li>"
    end.join
    
    list = "<li>" + 
      link_to_unless(params[:brand].nil?,
      "All brands",
      products_path(params.except(:controller, :action, :page).merge(brand: nil))) + 
      "</li>" + list

    "<ul>#{list}</ul>".html_safe
  end

  def operating_system_filter(operating_systems, params)
    list = operating_systems.map do |operating_system, count|
      "<li>" + 
        link_to_unless(params[:operating_system] == operating_system,
        "#{operating_system} (#{count})",
        products_path(params.except(:controller, :action, :page).merge({operating_system: operating_system}))) +
      "</li>"
    end.join
    
    list = "<li>" + 
      link_to_unless(params[:operating_system].nil?,
      "All OS",
      products_path(params.except(:controller, :action, :page).merge(operating_system: nil))) + 
      "</li>" + list

    "<ul>#{list}</ul>".html_safe

  end

  def hdd_type_filter(hdd_types, params)
    list = hdd_types.map do |hdd_type, count|
      "<li>" + 
        link_to_unless(params[:hdd_type] == hdd_type,
        "#{hdd_type} (#{count})",
        products_path(params.except(:controller, :action, :page).merge({hdd_type: hdd_type}))) +
      "</li>"
    end.join
    
    list = "<li>" + 
      link_to_unless(params[:hdd_type].nil?,
      "All HDD types",
      products_path(params.except(:controller, :action, :page).merge(hdd_type: nil))) + 
      "</li>" + list

    "<ul>#{list}</ul>".html_safe
  end

  def processor_filter(processors, params)
    list = processors.map do |processor, count|
      "<li>" + 
        link_to_unless(params[:processor] == processor,
        "#{processor} (#{count})",
        products_path(params.except(:controller, :action, :page).merge({processor: processor}))) +
      "</li>"
    end.join
    
    list = "<li>" + 
      link_to_unless(params[:processor].nil?,
      "All Processor Types",
      products_path(params.except(:controller, :action, :page).merge(processor: nil))) + 
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

  def display_resolution_filter(display_resolutions, params)
    list = display_resolutions.map do |display_resolution, count|
      "<li>" + 
        link_to_unless(
          params[:display_resolution] == display_resolution,
          "#{display_resolution} (#{count})",
          products_path(params.except(:controller, :action, :page).merge(display_resolution: display_resolution))) +
      "</li>"
    end.join

    list = "<li>" + 
      link_to_unless(
        params[:display_resolution].nil?,
        "All resolutions",
        products_path(params.except(:controller, :action, :page).merge(display_resolution: nil))) +
      "</li>" + list

    "<ul>#{list}</ul>".html_safe
  end
end
