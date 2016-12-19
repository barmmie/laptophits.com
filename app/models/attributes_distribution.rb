class AttributesDistribution
  ATTRIBUTES = Specification::SPEC_PARAMS.merge(price: :number])
  ATTR_PARAMS = {brand: [:brand],
                 price: [:price_from, :price_to],
                 display_size: [:display_size_from, :display_size_to],
                 ram_size: [:ram_size],
                 display_resolution: [:display_resolution],
                 operating_system: [:operating_system],
                 processor: [:processor]}


  attr_reader :scope, :filter_params

  def initialize(scope = Product.all, filter_params)
    @scope = scope
    @filter_params = filter_params
  end

  def calculate
    ATTRIBUTES.keys.map do |attr|
      results = ProductFilter.new(scope.unscoped).filter_by(filter_params.except(*ATTR_PARAMS[attr]))
      [attr,AttributesDistribution.new(results, filter_params).public_send("#{attr}_distribution")]
    end.to_h
  end

  def self.attr_distribution
    ATTRIBUTES.keys.map do |attr|
      [attr, public_send("#{attr}_distribution")]
    end.to_h
  end

  def display_size_distribution
    scope.all.map(&:display_size).map(&:to_i).sort.reverse.group_by(&:itself).map{|k,v| [k,v.length]}.to_h
  end

  def brand_distribution
    brands_distribution = scope.all.map(&:brand).group_by(&:itself).map{|k,v| [k,v.length]}.sort{|x,y| x <=> y || 1}.to_h
    brands_distribution['Other'] = brands_distribution.delete(nil) if brands_distribution[nil]
    brands_distribution
  end

  def ram_size_distribution
    rams_size_distribution = scope.all.map(&:ram_size).group_by(&:itself).except(nil).map{|k,v| [k,v.length]}.sort{|x,y| x <=> y || 1}.to_h
  end

  def display_resolution_distribution
    display_resolutions_distribution = scope.all.map(&:display_resolution).group_by(&:itself).except(nil).map{|k,v| [k,v.length]}.sort{|x,y| y <=> x || 1}.to_h
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

  def operating_system_distribution
    operating_systems_distribution = scope.all.map(&:operating_system).group_by(&:itself).map{|k,v| [k,v.length]}.sort{|x,y| y[1] <=> x[1] || 1}.to_h
    operating_systems_distribution['Uknown'] = operating_systems_distribution.delete(nil) if operating_systems_distribution[nil]
    operating_systems_distribution
  end

  def processor_distribution
    processors_distribution = scope.all.map(&:processor).group_by(&:itself).map{|k,v| [k,v.length]}.sort{|x,y| y[1] <=> x[1] || 1}.to_h
    processors_distribution['Uknown'] = processors_distribution.delete(nil) if processors_distribution[nil]
    processors_distribution
  end
end
