class Distribution
  attr_reader :values, :ranges

  def initialize(values, ranges = nil)
    @values = values
    @ranges = ranges
  end

  def calculate
    distribution = ranges ? range_distribution : value_distribution
    nil_values = distribution.delete(nil)
    distribution.sort.push([nil, nil_values]).to_h
  end

  private

  def value_distribution
    values.group_by(&:itself).map{|k,v| [k,v.length]}.to_h
  end

  #[1000, 500, 100, 0] ranges array => <0, 100), <100, 500), <500, 1000), <1000, inf)

  def range_distribution
    nil_values_count = values.count(nil)
    values_without_nils = values.reject(&:nil?)

    distr = ranges.map do |range|
      freq = values_without_nils.select{|value| value >= range}.length
      values_without_nils.reject!{|value| value >= range}

      [range, freq]
    end.to_h

    distr.merge!({nil => nil_values_count}) if nil_values_count > 0
    distr
  end
end

