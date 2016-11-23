class SpecificationExtractor
  attr_accessor :text

  def initialize(text)
    self.text = text
  end

  def display_size
    if match = text.match(/\b(\d{2}\.\d)\b|\b(\d{2})"|\b(\d{2})-Inch|\D(\d{2}\.\d)"/)
      match.captures.reject(&:nil?).first
    end
  end
end
