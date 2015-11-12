require './lib/district'
require 'pry'

class HeadcountAnalyst
  attr_reader :de_repo

  def initialize(district_repo)
    @de_repo = district_repo
  end

  def enrollment_average(district)
    enrollment_data = de_repo.find_by_name(district.upcase).enrollment.kindergarten_participation.values
    average = enrollment_data.inject(:+)/enrollment_data.size
  end


  def kindergarten_participation_rate_variation(district, hash_comparison)
    comparison = hash_comparison.values[0].upcase
    district_average = enrollment_average(district.upcase)
    comp_average = enrollment_average(comparison)
    rate_variation = district_average/comp_average
    rate_variation.round(3)
  end




  # ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO') # => 0.766

  # ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1') # => 1.234


  # ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO') # => {2009 => 0.766, 2010 => 0.566, 2011 => 0.46 }


end
