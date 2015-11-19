require 'pry'
class Enrollment
  attr_reader :name
  attr_accessor :high_school_graduation, :kindergarten

  def initialize(hash_line)
    @name = hash_line[:name]
    @kindergarten = hash_line[:kindergarten_participation]
    @high_school_graduation = hash_line[:high_school_graduation]
  end

  def kindergarten_participation_by_year
    truncated_values_hash = {}
    kindergarten.each do |k, v|
      truncated_values_hash[k] = truncate(v)
    end
    truncated_values_hash
  end

  def kindergarten_participation_in_year(year)
    if kindergarten.keys.include?(year)
      truncate(kindergarten[year])
    end
  end

  def graduation_rate_by_year
    truncated_values_hash = {}
    high_school_graduation.each do |k, v|
      truncated_values_hash[k] = truncate(v)
    end
    truncated_values_hash
  end

  def graduation_rate_in_year(year)
    if high_school_graduation.keys.include?(year)
      high_school_graduation[year]
    end
  end

  def set_kindergarten(value)
    @kindergarten = value
  end

  def set_high_school_graduation(value)
    @high_school_graduation = value
  end

  def truncate(float)
    (float * 1000).floor / 1000.to_f
  end
end

# e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
# all_years = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
# p 0.391, e.kindergarten_participation_in_year(2010)
# p e.kindergarten_participation_in_year(2012)
