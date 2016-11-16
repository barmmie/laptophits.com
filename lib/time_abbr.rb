class TimeAbbr
  TOKENS = {
    'min' => 1.minute,
    'h' => 1.hour,
    'd' => 1.day,
    'w' => 1.week,
    'm' => 1.month,
    'y' => 1.year
  }

  def self.to_time(input)
    input =~ /^(\d+)(\w+)$/
    $1.to_i * TOKENS[$2]
  end
end

