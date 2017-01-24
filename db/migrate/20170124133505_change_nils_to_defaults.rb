class ChangeNilsToDefaults < ActiveRecord::Migration
  def change
    Product.all.each do |p|
      p.price_updated_at || p.price_updated_at = Time.now
      p.amazon_api_data_updated_at || p.amazon_api_data_updated_at = Time.now
      p.amazon_www_data_updated_at || p.amazon_www_data_updated_at = Time.now
      p.save!
    end
  end
end

