class Specification
  VALUE_PARAMS = [
    :brand,
    :ram_size,
    :display_resolution,
    :operating_system,
    :processor,
    :hdd_type
  ]

  RANGE_PARAMS = {
   :price => [1500, 1000, 800, 600, 400, 0],
   :price_in_cents => [150000, 100000, 80000, 60000, 40000, 0],
   :display_size => [] ,
   :hdd_size => [1536,1024,512,256,128,0] 
  }

  NIL_NAMES = {
    brand: 'Other'
  }

  attr_reader :data_sources

  def initialize(data = [])
    @data_sources = data
  end

  def extract
    Specification.technical_details.map do |spec_param|
      extractor = "#{spec_param}_extractor".camelize.constantize
      [spec_param, extractor.new(data_sources).public_send(:extract)]
    end.to_h
  end

  def self.nil_name(param)
    NIL_NAMES[param] || 'Unknown'
  end

  def self.technical_details
    params - [:price, :price_in_cents]
  end

  def self.params
    VALUE_PARAMS + RANGE_PARAMS.keys
  end
  
  def self.range_params
    RANGE_PARAMS
  end

  def self.value_params
    VALUE_PARAMS
  end

  def self.filter_params
    params.map do |attr|
      if range_params.include? attr
        [attr, ["#{attr}_from".to_sym, "#{attr}_to".to_sym]]
      else
        [attr, [attr]]
      end
    end.to_h
  end
end
