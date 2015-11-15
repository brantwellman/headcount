class Enrollment
  attr_reader :name
  attr_accessor :high_school_graduation, :kindergarten

  def initialize(hash_line)
    @name = hash_line[:name]
    @kindergarten = hash_line[:kindergarten]
    @high_school_graduation = hash_line[:high_school_graduation]
  end

  # Returns a hash with years as keys and truncated 3 digit float representing percentage for all years in dataset
  def kindergarten_participation_by_year
    kindergarten
  end

  # Input is a year as integer. If no year found, return nil. Otherwise returns a truncated three-digit floating point number representing a percentage.
  def kindergarten_participation_in_year(year)
    if kindergarten.keys.include?(year)
      kindergarten[year]
    end
  end

  def graduation_rate_by_year
    high_school_graduation
  end

  def graduation_rate_in_year(year)
    if high_school_graduation.keys.include?(year)
      high_school_graduation[year]
    end
  end

end
