class District
  attr_reader :name, :enrollment, :year

  def initialize(hash_line)
    @name = hash_line[:name].upcase
    @year = hash_line[:year]
    @enrollment = hash_line[:enrollment]
  end
end
