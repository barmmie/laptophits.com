class AttributesDistribution
  ATTRIBUTES = [:brand, :price, :display_size, :ram, :display_resolution]
  ATTR_PARAMS = {brand: [:brand],
                 price: [:price_from, :price_to],
                 display_size: [:display_size_from, :display_size_to],
                 ram: [:ram],
                 display_resolution: [:display_resolution] }

  attr_reader :scope, :filter_params

  def initialize(scope = Product.all, filter_params)
    @scope = scope
    @filter_params = filter_params
  end

  def calculate
    ATTRIBUTES.map do |attr|
      results = ProductFilter.new(scope.unscoped).filter_by(filter_params.except(*ATTR_PARAMS[attr]))
      [attr,AttributesDistribution.new(results, filter_params).public_send("#{attr}_distribution")]
    end.to_h
  end

  def self.attr_distribution
    ATTRIBUTES.map do |attr|
      [attr, public_send("#{attr}_distribution")]
    end.to_h
  end

  def display_size_distribution
    scope.all.map(&:display_size).map(&:to_i).sort.reverse.group_by(&:itself).map{|k,v| [k,v.length]}.to_h
  end

  def brand_distribution
    brands_distribution = scope.all.map(&:brand).group_by(&:itself).map{|k,v| [k,v.length]}.sort{|x,y| x <=> y || 1}.to_h
    brands_distribution['Other'] = brands_distribution.delete('Other') if brands_distribution['Other']
    brands_distribution
  end

  def ram_distribution
    rams_distribution = scope.all.map(&:ram).group_by(&:itself).except(nil).map{|k,v| [k,v.length]}.sort{|x,y| x <=> y || 1}.to_h
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

end
