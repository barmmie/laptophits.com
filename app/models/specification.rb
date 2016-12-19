class Specification
  SPEC_PARAMS = {
    brand: :number,
    ram_size: :number,
    display_size: :number,
    display_resolution: :string,
    operating_system: :string,
    processor: :string }

  attr_reader :data_sources

  def initialize(data = [])
    @data_sources = data
  end

  def extract
    spec_params.map do |spec_param|
      extractor = "#{spec_param}_extractor".camelize.constantize
      [spec_param, extractor.new(data_sources).public_send(:extract)]
    end.to_h
  end

  def spec_params
    SPEC_PARAMS.keys
  end
end
