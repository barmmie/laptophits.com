class AttributesDistribution
  attr_reader :scope, :filter_params

  def initialize(scope = Product.all, filter_params)
    @scope = scope
    @filter_params = filter_params
  end

  def self.attr_distribution
    Specification.params.map do |attr|
      [attr, public_send("#{attr}_distribution")]
    end.to_h
  end

  def calculate
    Specification.params.map do |attr|
      results = ProductFilter.new(scope.unscoped).filter_by(filter_params.except(*Specification.filter_params[attr]))
      [attr,AttributesDistribution.new(results, filter_params).public_send("#{attr}_distribution")]
    end.to_h
  end


  
  def range_attribute_distribution(attribute_name, params = {})
    values = scope.all.map{|product| product.public_send(attribute_name)}
    Distribution.new(values, params[:ranges]).calculate
  end

  def value_attribute_distribution(attribute_name, params = {})
    values = scope.all.map{|product| product.public_send(attribute_name)}
    Distribution.new(values).calculate
  end


  def price_in_cents_distribution
    range_attribute_distribution(:price_in_cents, ranges: [150000, 100000, 80000, 60000, 40000, 0], nil_values: false)
  end

  def hdd_size_distribution
    range_attribute_distribution(:hdd_size, ranges: [1536,1024,512,256,128,0], nil_values: true)
  end

  def price_distribution
    initial_distribution = price_in_cents_distribution
    no_prices_count = initial_distribution.delete(nil)

    initial_distribution.map{|price_range, count| [price_range/100, count]}.push([nil, no_prices_count]).to_h
  end


  def operating_system_distribution
    value_attribute_distribution(:operating_system, sort_by: :name)
  end

  def processor_distribution
    value_attribute_distribution(:processor, nil_values: true )
  end

  def hdd_type_distribution
    value_attribute_distribution(:hdd_type, nil_values: true)
  end

  def brand_distribution
    value_attribute_distribution(:brand, sort_by: :name, nil_values: true)
  end

  def ram_size_distribution
    value_attribute_distribution(:ram_size, sort_by: :name, nil_values: false)
  end

  def display_resolution_distribution
    value_attribute_distribution(:display_resolution, sort_by: :name, nil_values: false)
  end

  def display_size_distribution
    scope.all.map(&:display_size).map(&:to_i).sort.reverse.group_by(&:itself).map{|k,v| [k,v.length]}.to_h
  end
end
