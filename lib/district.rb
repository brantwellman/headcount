class District
  attr_reader :name
  attr_accessor :enrollment, :statewide_test, :economic_profile

  def initialize(hash_line)
    @name = hash_line[:name]
  end

  def set_enrollment(value)
    @enrollment = value
  end

  def set_statewide_testing(value)
    @statewide_test = value
  end

  def set_economic_profile(value)
    @economic_profile = value
  end
end
