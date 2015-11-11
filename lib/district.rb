class District
  attr_reader :name

  def initialize(hash_line)
    @name = hash_line[:name]
  end
end
