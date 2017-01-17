class HddSizeFilterOption < SpecificationFilterOption
  def is_active?
    params[:hdd_size_from] == value.to_s && params[:hdd_size_to] == hdd_size_to
  end

  def text
    {
      0 => "127GB & Under" ,
      128 => "128GB to 255GB",
      256 => "256GB to 0.49TB",
      512 => "0.5TB to 0.99TB",
      1024 => "1TB to 1.49TB",
      1536 => "1.5TB & Above"
    }[value] + " (#{count})"
  end

  def href
    products_path(filter_params.merge({ hdd_size_from: value, hdd_size_to: hdd_size_to}))
  end

  def hdd_size_to
    value_index = Specification.range_params[:hdd_size].index value
    if value_index == 0
      nil
    else
      to_value = Specification.range_params[:hdd_size][value_index - 1] 
      to_value.to_s
    end
  end
end
