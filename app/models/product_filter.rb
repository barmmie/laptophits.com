class ProductFilter
  attr_reader :scope

  def initialize(scope = Product.all)
    @scope = scope
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

  def brand(brand_name)
    scope.where(brand: brand_name)
  end

  def operating_system(os)
    scope.where(operating_system: os)
  end

  def ram_size(ram_size)
    scope.where(ram_size: ram_size)
  end

  def display_resolution(display_resolution)
    scope.where(display_resolution: display_resolution)
  end

  def display_size_from(display_size)
    scope.where('display_size >= ?', display_size)
  end

  def display_size_to(display_size)
    scope.where('display_size < ?', display_size)
  end
end
