require_relative 'district'
require_relative 'enrollment'
require_relative 'district_repository'
require 'pry'

class HeadcountAnalyst
  attr_reader :de_repo

  def initialize(district_repo)
    @de_repo = district_repo
  end

  def enrollment_average(district)
    district = de_repo.find_by_name(district.upcase)
    enrollment_data = district.enrollment.kindergarten.values.compact
    return nil if enrollment_data.empty?
    enrollment_data.inject(:+)/enrollment_data.length

  end

  def kindergarten_participation_rate_variation(district, comparison)
    comparison = comparison.values[0].upcase
    district_average = enrollment_average(district.upcase)
    comp_average = enrollment_average(comparison)
    unless district_average && comp_average
      return nil
    end
    rate_variation = district_average/comp_average
    rate_variation
    truncate(rate_variation)
  end

  def find_kinder_part_by_year_for_district(district)
     de_repo.find_by_name(district).enrollment.kindergarten
  end

  def kindergarten_participation_rate_variation_trend(district, hash_comparison)
    comparison = hash_comparison.values[0].upcase
    dist_part = find_kinder_part_by_year_for_district(district)
    comparison_part = find_kinder_part_by_year_for_district(comparison)
    result = {}
    dist_part.keys.map do | year|
      result[year] = truncate(dist_part[year] / comparison_part[year])
    end
    result
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kind_rate = kindergarten_participation_rate_variation(district, :against => "Colorado")
    hs_rate_var = high_school_graduation_rate_variation(district, "Colorado")
    return nil unless kind_rate && hs_rate_var
    truncate(kind_rate / hs_rate_var)
  end

  def high_school_graduation_rate_variation(district, comparison)
    district_average = hs_graduation_average(district.upcase)
    comp_average = hs_graduation_average(comparison.upcase)
    return nil unless district_average && comp_average
    rate_variation = district_average/comp_average
    truncate(rate_variation)
  end

  def hs_graduation_average(district)
    district = de_repo.find_by_name(district)
    hs_grad_data = district.enrollment.high_school_graduation.values
    hs_grad_data = hs_grad_data.compact
    return nil if hs_grad_data.empty?
    hs_grad_data.inject(:+)/hs_grad_data.size
  end

  # required method call - long lenth
  def kindergarten_participation_correlates_with_high_school_graduation(comparison)
    if comparison.has_key?(:across)
      subset_of_districs_hs_kinder_across_districts(comparison)
  elsif comparison.has_key?(:for) && comparison[:for] == "STATEWIDE" ||
    comparison.has_key?(:for) && comparison[:for] == "COLORADO" ||
      statewide_correlation_hs_kinder_across_districts
    elsif comparison.has_key?(:for)
      kinder_part_vs_high_school_grad_correlation_window(comparison)
    end
  end

  def kinder_part_vs_high_school_grad_correlation_window(hash_district)
    district = hash_district[:for]
    # required method call - long lenq
    k_vs_hs = kindergarten_participation_against_high_school_graduation(district)
    return nil unless k_vs_hs
    (0.6 <= k_vs_hs && k_vs_hs <= 1.5) ? true : false
  end

  def statewide_correlation_hs_kinder_across_districts
    enrollment_repo = @de_repo.enrollment_repository.enrollments
    districts_corellations = enrollment_repo.map do |enrollment|
        kinder_part_vs_high_school_grad_correlation_window(for: enrollment.name)
    end
    districts_corellations.shift
    true_count = districts_corellations.count(true)
    (true_count / districts_corellations.count) > 0.7 ? true : false
  end

  def subset_of_districs_hs_kinder_across_districts(districts_array_hash)
    districts = districts_array_hash[:across]
    districts_corellations = districts.map do |district|
      kinder_part_vs_high_school_grad_correlation_window(for: district)
      #binding.pry
    end
    districts_corellations
    true_count = districts_corellations.count(true)
    (true_count / districts_corellations.count) > 0.7 ? true : false
  end

  def truncate(float)
    # binding.pry
    (float * 1000).floor / 1000.to_f
  end
end

# dr = DistrictRepository.new
# dr.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv",
#     :high_school_graduation => "./data/High school graduation rates.csv"
#   }
# })
#
# ha = HeadcountAnalyst.new(dr)
# hash_comparison = {for: "ACADEMY 20"}
# # hash_comparison = {:across => ['ACADEMY 20', 'AGATE 300', 'ADAMS COUNTY 14']}
# districts = {:across =>["Colorado", "Agate 300"]}
# ha.subset_of_districs_hs_kinder_across_districts(districts)
#  p ha.statewide_correlation_hs_kinder_across_districts
# # true_count = districts_corellations.count(false)
# p ha.kindergarten_participation_correlates_with_high_school_graduation(hash_comparison)
