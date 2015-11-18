class District
  attr_reader :name
  attr_accessor :enrollment, :statewide_test

  def initialize(hash_line)
    @name = hash_line[:name]
  end

  def set_enrollment(value)
    @enrollment = value
  end

  def set_statewide_testing(value)
    @statewide_test = value
  end
end
