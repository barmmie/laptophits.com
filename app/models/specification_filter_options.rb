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

  class RangeFilterOption < SpecificationFilterOption
    def is_active?
      params["#{attribute_name}_from".to_sym] == value.to_s && params["#{attribute_name}_to".to_sym] == _to
    end

    def href
      products_path(params.merge({"#{attribute_name}_from".to_sym => value, "#{attribute_name}_to".to_sym => _to}))
    end

    def _to
      value_index = Specification.range_params[attribute_name].index value

      if value_index == 0
        nil
      else
        Specification.range_params[attribute_name][value_index - 1].to_s
      end
    end
  end

  class PriceFilterOption < RangeFilterOption 
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

  class HddSizeFilterOption < RangeFilterOption
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
  end
end
