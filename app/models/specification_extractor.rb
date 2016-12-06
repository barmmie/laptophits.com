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

  def ram
    ram_patterns = [
     /(\d+) ?GB (?:LP)?DDR/i,
     /(\d+) ?GB RAM/i,
     /(\d+) ?GB ?Memory/i,
     /(\d+) ?G?GB? ?,? ?\d+ ?(?:GB?|TB?)/i,
     /(\d+ ?G2) RAM/i,
     /hz (\d+) ?GB/i,
     /(\d+) ?GB ?- ?\d+ ?GB/i
    ]

    re = Regexp.union(ram_patterns)

    if match = text.match(re)
      match.captures.reject(&:nil?).first
    end
  end
end
