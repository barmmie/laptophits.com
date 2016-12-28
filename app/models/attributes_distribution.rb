class AttributesDistribution
  attr_reader :scope, :filter_params

  def initialize(scope = Product.all, filter_params)
    @scope = scope
    @filter_params = filter_params
  end

  def self.distr_attributes 
    Specification::SPEC_PARAMS + [:price]
  end

  def self.range_distr_attributes
    %i(price display_size)
  end

  def self.attributes_filter_params
    distr_attributes.map do |attr|
      if range_distr_attributes.include? attr
        [attr, ["#{attr}_from".to_sym, "#{attr}_to".to_sym]]
      else
        [attr, [attr]]
      end
    end.to_h
  end


  def calculate
    self.class.distr_attributes.map do |attr|
      results = ProductFilter.new(scope.unscoped).filter_by(filter_params.except(*self.class.attributes_filter_params[attr]))
      [attr,AttributesDistribution.new(results, filter_params).public_send("#{attr}_distribution")]
    end.to_h
  end

  def self.attr_distribution
    distr_attributes.map do |attr|
      [attr, public_send("#{attr}_distribution")]
    end.to_h
  end

  def price_in_cents_distribution
    price_ranges = [150000, 100000, 80000, 60000, 40000, 0]
    values = scope.all.map(&:price_in_cents)
    no_price_count = values.count(nil)

    values = values.reject(&:nil?)

    price_ranges.map do |price_range|
      price_range_count = values.select{|value| value >= price_range}.length
      values.reject!{|value| value >= price_range}

      [price_range, price_range_count]
    end.reverse.to_h.merge({nil => no_price_count})
  end

  def price_distribution
    initial_distribution = price_in_cents_distribution
    no_prices_count = initial_distribution.delete(nil)

    initial_distribution.map{|price_range, count| [price_range/100, count]}.push([nil, no_prices_count]).to_h
  end

  def attribute_distribution(attribute_name, params = {})
    attributes_distribution = scope.all.map{|product| product.public_send(attribute_name)}.group_by(&:itself).map{|k,v| [k,v.length]}.to_h
    nil_count = attributes_distribution.delete(nil)
    if params[:sort_by] == :count
      attributes_distribution = attributes_distribution.sort{|x,y| y[1] <=> x[1] || 1}.to_h
    else
      attributes_distribution = attributes_distribution.sort{|x,y| x[0] <=> y[0] || 1}.to_h
    end
      
    attributes_distribution[ProductFilter::NIL_NAMES[attribute_name]] = nil_count if nil_count && params[:nil_values] == true

    attributes_distribution
  end

  def operating_system_distribution
    attribute_distribution(:operating_system, sort_by: :name)
  end

  def processor_distribution
    attribute_distribution(:processor, nil_values: true )
  end

  def hdd_type_distribution
    attribute_distribution(:hdd_type, nil_values: true)
  end

  def brand_distribution
    attribute_distribution(:brand, sort_by: :name, nil_values: true)
  end

  def ram_size_distribution
    attribute_distribution(:ram_size, sort_by: :name, nil_values: false)
  end

  def display_resolution_distribution
    attribute_distribution(:display_resolution, sort_by: :name, nil_values: false)
  end

  def display_size_distribution
    scope.all.map(&:display_size).map(&:to_i).sort.reverse.group_by(&:itself).map{|k,v| [k,v.length]}.to_h
  end

end
