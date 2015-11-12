class District
  attr_reader :name
  attr_accessor :enrollment

  def initialize(hash_line)
    @name = hash_line[:name]
  end
end
