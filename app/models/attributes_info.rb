module AttributesInfo
  SPEC_PARAMS = %i(brand ram_size display_size display_resolution operating_system processor hdd_type hdd_size)
  VALUE_PARAMS = %i(brand operating_system hdd_type processor ram_size display_resolution)
  RANGE_PARAMS = %i(price display_size hdd_size)
  NIL_NAMES = {brand: 'Other'}

  def nil_name(attr)
    NIL_NAMES[attr] || 'Unknown'
  end
end
