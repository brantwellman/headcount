class Enrollment
  attr_reader :kindergarten_participation

  def initialize(data_hash)
    name = data_hash[:name.downcase]
    kindergarten_participation = data_hash[:kindergarten_participation]
  end

  # Returns a hash with years as keys and truncated 3 digit float representing percentage for all years in dataset
  def kindergarten_participation_by_year
    kindergarten_participation
    # => { 2010 => 0.391,
    #      2011 => 0.353,
    #      2012 => 0.267,
    #    }
  end

  # Input is a year as integer. If no year found, return nil. Otherwise returns a truncated three-digit floating point number representing a percentage.
  def kindergarten_participation_in_year(year)
    kindergarten_participation[year].round(3)
    # 0.391
  end
end



# e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})
