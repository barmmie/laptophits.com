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

  #default distributions 
 
  Specification.params.each do |param|
    define_method "#{param}_distribution".to_sym do
      values = scope.all.map{|product| product.public_send(param)}
      Distribution.new(values, Specification.range_params[param]).calculate
    end
  end

  #custom distributions

  def display_size_distribution
    scope.all.map(&:display_size).map(&:to_i).sort.reverse.group_by(&:itself).map{|k,v| [k,v.length]}.to_h
  end

  def price_distribution
    initial_distribution = price_in_cents_distribution
    no_prices_count = initial_distribution.delete(nil)

    initial_distribution.map{|price_range, count| [price_range/100, count]}.push([nil, no_prices_count]).to_h
  end
end
