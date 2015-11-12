require './lib/district'
require 'pry'

class HeadcountAnalyst
  attr_reader :de_repo

  def initialize(district_repo)
    @de_repo = district_repo
  end

  def gather_enrollment_average_for_district(district)
    enrollment_data_for_district = de_repo.find_by_name(district).enrollment.kindergarten_participation.values
    average = enrollment_data_for_district.inject(:+)/enrollment_data_for_district.size
  end


  def kindergarten_participation_rate_variation(district, comparison)
    district_average = gather_enrollment_average_for_district(district)
    comp_average = gather_enrollment_average_for_district(comparison)
    district_average/comp_average
  end




  # ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO') # => 0.766

  # ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1') # => 1.234


  # ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO') # => {2009 => 0.766, 2010 => 0.566, 2011 => 0.46 }


end
