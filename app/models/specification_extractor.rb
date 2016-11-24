class SpecificationExtractor
  attr_accessor :text

  def initialize(text)
    self.text = text
  end

  def display_size
    if match = text.match(/\b(\d{2}\.\d)(?:\b|in)|\b(\d{2})(?:"|[-]in)|\b(\d{2})[ -]Inch|\D(\d{2}\.\d)"/i)
      match.captures.reject(&:nil?).first
    end
  end
end
