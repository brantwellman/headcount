class District
  attr_reader :name, :enrollment, :year

  def initialize(hash_line)
    @name = hash_line[:name].downcase
    @year = hash_line[:year]
    @enrollment_percent = hash_line[enrollment]
  end
end
#{:name => "Colorado", :year => 1999, :enrollment => 0.5867}
