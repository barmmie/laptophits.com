class Product < ActiveRecord::Base
  ATTRIBUTES = [:brand, :price, :display_size, :ram]
  ATTR_PARAMS = {brand: [:brand],
                 price: [:price_from, :price_to],
                 display_size: [:display_size_from, :display_size_to],
                 ram: [:ram]}

  has_many :mentions, dependent: :destroy
  has_many :comments, through: :mentions

  def update_spec
    update_attributes( Specification.new(title: title, amazon_api_data: amazon_api_data).extract )
  end

  def to_param
    "#{id} #{title}".parameterize
  end

  def self.filter_by(filter_params)
    results = joins(:comments).
      select('products.*, count(mentions.product_id) as "mentions_count"').
      group('products.id').
      order('mentions_count DESC')

    filter_params.each do |key, value|
      results = results.public_send(key, value) if value.present?
    end

    results
  end

  def self.after(time)
      where('comments.created_utc > ?', Time.now - ::TimeAbbr.to_time(time))
  end

  def self.price_from(price)
    where('price_in_cents >= ?', price.to_f*100)
  end

  def self.price_to(price)
    where('price_in_cents < ?', price.to_f*100)
  end

  def self.brand(brand_name)
    where(brand: brand_name)
  end

  def self.ram(ram_size)
    where(ram: ram_size)
  end

  def self.display_size_from(display_size)
    where('display_size >= ?', display_size)
  end

  def self.display_size_to(display_size)
    where('display_size < ?', display_size)
  end

  def self.filter_attr_distribution(filter_params)
    ATTRIBUTES.map do |attr|
      results = unscoped.filter_by(filter_params.except(*ATTR_PARAMS[attr]))
      [attr,results.public_send("#{attr}_distribution")]
    end.to_h

  end

  def self.attr_distribution
    ATTRIBUTES.map do |attr|
      [attr, public_send("#{attr}_distribution")]
    end.to_h
  end

  def self.display_size_distribution
    all.map(&:display_size).map(&:to_i).sort.reverse.group_by(&:itself).map{|k,v| [k,v.length]}.to_h
  end

  def self.brand_distribution
    brands_distribution = all.map(&:brand).group_by(&:itself).map{|k,v| [k,v.length]}.sort{|x,y| x <=> y || 1}.to_h
    brands_distribution['Other'] = brands_distribution.delete('Other') if brands_distribution['Other']
    brands_distribution
  end

  def self.ram_distribution
    rams_distribution = all.map(&:ram).group_by(&:itself).except(nil).map{|k,v| [k,v.length]}.sort{|x,y| x <=> y || 1}.to_h
  end

  def self.price_in_cents_distribution
    price_ranges = [150000, 100000, 80000, 60000, 40000, 0]
    values = all.map(&:price_in_cents)
    no_price_count = values.count(nil)

    values = values.reject(&:nil?)

    price_ranges.map do |price_range|
      price_range_count = values.select{|value| value >= price_range}.length
      values.reject!{|value| value >= price_range}

      [price_range, price_range_count]
    end.reverse.to_h.merge({nil => no_price_count})
  end

  def self.price_distribution
    initial_distribution = price_in_cents_distribution
    no_prices_count = initial_distribution.delete(nil)

    initial_distribution.map{|price_range, count| [price_range/100, count]}.push([nil, no_prices_count]).to_h
  end

end
