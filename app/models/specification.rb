class Specification
  VALUE_PARAMS = [
    :brand,
    :ram_size,
    :display_resolution,
    :operating_system,
    :processor,
    :hdd_type ]

  RANGE_PARAMS = [
   :price,
   :display_size,
   :hdd_size ]

  NIL_NAMES = {
    brand: 'Other'
  }

  attr_reader :data_sources

  def initialize(data = [])
    @data_sources = data
  end

  def extract
    SPEC_PARAMS.map do |spec_param|
      extractor = "#{spec_param}_extractor".camelize.constantize
      [spec_param, extractor.new(data_sources).public_send(:extract)]
    end.to_h
  end

  def self.nil_name(param)
    NIL_NAMES[param] || 'Unknown'
  end

  def self.params
    VALUE_PARAMS + RANGE_PARAMS
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
