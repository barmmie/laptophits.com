class Specification
  include AttributesInfo

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
