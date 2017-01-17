module SpecificationFilterOptions

  class SpecificationFilterOption
    attr_reader :attribute_name, :params, :value, :count

    include Rails.application.routes.url_helpers
    include ActionView::Helpers
    include ActionView::Context

    def initialize(attribute_name, params, value, count)
      @value = value
      @count = count
      @attribute_name = attribute_name
      @params = params
    end

    def html
      return '' if count == 0

      content_tag :li do
        link_to_unless(is_active?, text, href)
      end
    end

    def is_active?
      params[attribute_name] == value
    end

    def text
      "#{value} (#{count})"
    end

    def href
      products_path(params.merge({attribute_name => value}))
    end
  end

  class PriceFilterOption < SpecificationFilterOption
    def is_active?
      params[:price_from] == value.to_s && params[:price_to] == price_to
    end

    def text
      {
        0 => "$0 - $400", 
        400 => "$400 - $600",
        600 => "$600 - $800",
        800 => "$800 - $1000",
        1000 => "$1000 - $1500",
        1500 => "$1500+"
      }[value] + " (#{count})"
    end

    def href
      products_path(params.merge({ price_from: value, price_to: price_to}))
    end

    def price_to
      value_index = Specification.range_params[:price].index value
      if value_index == 0
        nil
      else
        to_value = Specification.range_params[:price][value_index - 1] 
        to_value.to_s
      end
    end
  end

  class RamSizeFilterOption < SpecificationFilterOption
    def text
      "#{value} GB (#{count})"
    end

    def is_active?
      params[attribute_name].to_i == value
    end
  end

  class DisplaySizeFilterOption < SpecificationFilterOption
    def text
      "#{value}\" - #{value}.9\" (#{count})"
    end

    def href
      products_path(params.merge({ display_size_from: value, display_size_to: value + 1}))
    end
  end

  class HddSizeFilterOption < SpecificationFilterOption
    def is_active?
      params[:hdd_size_from] == value.to_s && params[:hdd_size_to] == hdd_size_to
    end

    def text
      {
        0 => "127GB & Under" ,
        128 => "128GB to 255GB",
        256 => "256GB to 0.49TB",
        512 => "0.5TB to 0.99TB",
        1024 => "1TB to 1.49TB",
        1536 => "1.5TB & Above"
      }[value] + " (#{count})"
    end

    def href
      products_path(params.merge({ hdd_size_from: value, hdd_size_to: hdd_size_to}))
    end

    def hdd_size_to
      value_index = Specification.range_params[:hdd_size].index value
      if value_index == 0
        nil
      else
        to_value = Specification.range_params[:hdd_size][value_index - 1] 
        to_value.to_s
      end
    end
  end
end
