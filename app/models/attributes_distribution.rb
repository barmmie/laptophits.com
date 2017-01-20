class AttributesDistribution
  attr_reader :scope, :filter_params

  def initialize(scope = Product.all, filter_params)
    @scope = scope
    @filter_params = filter_params
  end

  def calculate
    Specification.params.map do |attr|
      results = ProductFilter.new(scope.unscoped).filter_by(filter_params.except(*Specification.filter_params[attr]))
      [attr,AttributesDistribution.new(results, filter_params).public_send("#{attr}_distribution")]
    end.to_h
  end

  def display_size_distribution
    display_sizes = scope.all.map(&:display_size)
    no_display_size_count = display_sizes.select(&:nil?).length

    display_sizes.reject!(&:nil?)

    display_sizes.map(&:to_i).sort.reverse.group_by(&:itself).map{|k,v| [k,v.length]}.push([nil, no_display_size_count]).to_h
  end

  def price_distribution
    initial_distribution = price_in_cents_distribution
    no_prices_count = initial_distribution.delete(nil)

    initial_distribution.map{|price_range, count| [price_range/100, count]}.sort.push([nil, no_prices_count]).to_h
  end

  def ram_size_distribution
    ram_distr = default_distribution(:ram_size)
    nil_distr = ram_distr.slice(nil)
    ram_distr.except(nil).sort.reverse.to_h.merge(nil_distr)
  end

  def default_distribution(param)
    values = scope.all.map{|product| product.public_send(param)}
    Distribution.new(values, Specification.range_params[param]).calculate
  end

  def method_missing(m, *args, &block)  
    if m.to_s =~ /^(\w+)_distribution$/
      default_distribution($1.to_sym)
    else
      super
    end
  end  
end
