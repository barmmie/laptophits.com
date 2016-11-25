class Product < ActiveRecord::Base
  has_many :mentions
  has_many :comments, through: :mentions

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


end
