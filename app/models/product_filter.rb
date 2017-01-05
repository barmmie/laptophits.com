class ProductFilter
  attr_reader :scope

  def initialize(scope = Product.all)
    @scope = scope
  end

  Specification.value_params.each do |param|
    define_method param do |value|
      scope.where(param => value == Specification.nil_name(param) ? nil : value)
    end
  end

  Specification.range_params.keys.each do |param|
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
