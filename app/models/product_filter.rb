class ProductFilter
  VALUE_PARAMS = %i(brand operating_system hdd_type processor ram_size display_resolution)
  RANGE_PARAMS = %i(price display_size)
  NIL_NAMES = {brand: 'Other', operating_system: 'Unknown',
               hdd_type: 'Uknown', processor: 'Unknown', ram_size: 'Unknown',
               display_resolution: 'Unknown'}

  attr_reader :scope

  def initialize(scope = Product.all)
    @scope = scope
  end

  VALUE_PARAMS.each do |param|
    define_method param do |value|
      scope.where(param => value == NIL_NAMES[param] ? nil : value)
    end
  end

  RANGE_PARAMS.each do |param|
    define_method "#{param}_from".to_sym do |value|
      scope.where("#{param} >= ?", value)
    end

    define_method "#{param}_to".to_sym do |value|
      scope.where("#{param} < ?", value)
    end
  end

  def filter_by(filter_params)
    results = scope.joins(:comments).
      select('products.*, count(mentions.product_id) as "mentions_count"').
      group('products.id').
      order('mentions_count DESC')

    filter_params.each do |key, value|
      results = ProductFilter.new(results).public_send(key, value) if value.present?
    end

    results
  end

  #custom filters

  def after(time)
    scope.where('comments.created_utc > ?', Time.now - ::TimeAbbr.to_time(time))
  end

  def price_from(price)
    scope.where('price_in_cents >= ?', price.to_f*100)
  end

  def price_to(price)
    scope.where('price_in_cents < ?', price.to_f*100)
  end
end
