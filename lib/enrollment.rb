class Enrollment
  attr_reader :kindergarten_participation, :name

  def initialize(hash_line)
    @name = hash_line[:name].upcase
    @kindergarten_participation = hash_line[:kindergarten_participation]
  end

  # Returns a hash with years as keys and truncated 3 digit float representing percentage for all years in dataset
  def kindergarten_participation_by_year
    kindergarten_participation.inject({}) {|h, (k, v)| h[k] = v; h}
  end

  # Input is a year as integer. If no year found, return nil. Otherwise returns a truncated three-digit floating point number representing a percentage.
  def kindergarten_participation_in_year(year)
    if kindergarten_participation.keys.include?(year)
      kindergarten_participation[year]
    end
  end
end
