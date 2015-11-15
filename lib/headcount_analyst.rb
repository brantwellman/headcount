require './lib/district'
require './lib/enrollment'
require './lib/district_repository'
require 'pry'

class HeadcountAnalyst
  attr_reader :de_repo

  def initialize(district_repo)
    @de_repo = district_repo
  end

  def enrollment_average(district)
    enrollment_data = de_repo.find_by_name(district.upcase).enrollment.kindergarten.values
    average = enrollment_data.inject(:+)/enrollment_data.size
  end

  def kindergarten_participation_rate_variation(district, hash_comparison)
    comparison = hash_comparison.values[0].upcase
    district_average = enrollment_average(district.upcase)
    comp_average = enrollment_average(comparison)
    rate_variation = district_average/comp_average
    rate_variation.round(3)
  end

  def find_kindergarten_participation_by_year_for_district(district)
     de_repo.find_by_name(district).enrollment.kindergarten
  end

  def kindergarten_participation_rate_variation_trend(district, hash_comparison)
    comparison = hash_comparison.values[0].upcase
    district_participation = find_kindergarten_participation_by_year_for_district(district)
    comparison_participation = find_kindergarten_participation_by_year_for_district(comparison)
    result = {}
    district_participation.keys.map do | year|
      result[year] = (district_participation[year] / comparison_participation[year]).round(3)
    end
    result
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kinder_rate_var = kindergarten_participation_rate_variation(district, :against => "Colorado")
    hs_rate_var = high_school_graduation_rate_variation(district, "Colorado")
    (kinder_rate_var / hs_rate_var).round(3)
  end


  def high_school_graduation_rate_variation(district, comparison)
    district_average = hs_graduation_average(district.upcase)
    comp_average = hs_graduation_average(comparison.upcase)
    rate_variation = district_average/comp_average
    rate_variation.round(3)
  end

  def hs_graduation_average(district)
    # binding.pry
    hs_grad_data = de_repo.find_by_name(district).enrollment.high_school_graduation.values
    hs_grad_data.inject(:+)/hs_grad_data.size
  end


  def kindergarten_participation_correlates_with_high_school_graduation(hash_comparison)
    #   if key is :across,
    if hash_comparison.has_key?(:across)
    #     call method for districts contained in array
      subset_of_districs_hs_kinder_across_districts(hash_comparison)
    #   elsif key is :for and value is "Colorado"
    elsif hash_comparison.has_key?(:for) && hash_comparison[:for] == "COLORADO"
        #  call method comparing districts vs colorado
      statewide_correlation_hs_kinder_across_districts
      # elsif key is :for and value is something else
    elsif hash_comparison.has_key?(:for)
      #   call method for individual district
      kindergarten_participation_against_high_school_graduation_correlation_window(hash_comparison)
    end
  end

  def kindergarten_participation_against_high_school_graduation_correlation_window(hash_district)
    district = hash_district[:for] #.values
    k_vs_hs = kindergarten_participation_against_high_school_graduation(district)
    (0.6 <= k_vs_hs && k_vs_hs <= 1.5) ? true : false
  end

  def statewide_correlation_hs_kinder_across_districts
    districts_corellations = @de_repo.enrollment_repository.enrollments.map do |enrollment|
        kindergarten_participation_against_high_school_graduation_correlation_window(for: enrollment.name)
    end
    districts_corellations.shift
    true_count = districts_corellations.count(true)
    (true_count / districts_corellations.count) > 0.7 ? true : false
  end

  def subset_of_districs_hs_kinder_across_districts(districts_array_hash)
    districts = districts_array_hash[:across]
    districts_corellations = districts.map do |district|
      kindergarten_participation_against_high_school_graduation_correlation_window(for: district)
    end
    districts_corellations
    true_count = districts_corellations.count(true)
    (true_count / districts_corellations.count) > 0.7 ? true : false
  end
end

dr = DistrictRepository.new
dr.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
  }
})
#
ha = HeadcountAnalyst.new(dr)
hash_comparison = {for: "ACADEMY 20"}
# hash_comparison = {:across => ['ACADEMY 20', 'AGATE 300', 'ADAMS COUNTY 14']}
# districts = {:across =>["Colorado", "Agate 300"]}
# ha.subset_of_districs_hs_kinder_across_districts(districts)
#  p ha.statewide_correlation_hs_kinder_across_districts
# true_count = districts_corellations.count(false)
p ha.kindergarten_participation_correlates_with_high_school_graduation(hash_comparison)
