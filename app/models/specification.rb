class Specification
  SPEC_PARAMS = %i(brand ram_size display_size display_resolution operating_system processor hdd_type)

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
end
