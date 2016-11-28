module ProductsHelper
  def brand_filter(brands, params)
    list = brands.map do |brand, count|
      "<li>" + 
        link_to_unless(params[:brand] == brand,
        "#{brand} (#{count})",
        products_path(params.except(:controller, :action).merge({brand: brand}))) +
      "</li>"
    end.join

    "<ul>#{list}</ul>".html_safe
  end

  def display_size_filter(display_sizes, params)
    list = display_sizes.except(0).map do |display_size, count| 
      "<li>" + 
        link_to_unless(
          params[:display_size_from].to_i == display_size && params[:display_size_to].to_i == display_size + 1,
          "#{display_size}\" - #{display_size}.9\" (#{count})",
          products_path(params.except(:controller, :action).merge({display_size_from: display_size, display_size_to: display_size + 1}))) +
      "</li>"
    end.join

    "<ul>#{list}</ul>".html_safe
  end
end
