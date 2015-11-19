require_relative 'district'
require_relative 'enrollment'
require_relative 'district_repository'
require_relative 'insufficient_information_error'
require_relative 'unknown_data_error'
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

  def kinder_part_rate_variation(district, comparison)
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
    kind_rate = kinder_part_rate_variation(district, :against => "Colorado")
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
    end
    districts_corellations
    true_count = districts_corellations.count(true)
    (true_count / districts_corellations.count) > 0.7 ? true : false
  end

  def top_statewide_test_year_over_year_growth(data_hash)
#   throw error ################### not passing yet
    raise InsufficientDataError.new("Need a grade to proceed") if data_hash.has_key?(:grade)
#   dive in, get rid of nils in hash(es)
    hash_minus_nils = go_into_hash_and_eliminate_nils(data_hash)
#   make sure there are two or more years left
#     else throw error
    raise InsufficientDataError.new("Not enought data") unless count_key_value_pairs(hash_minus_nils)


#   get growth value
    district_growth_values(hash_minus_nils)
#   grab district name
#   need array of arrays containing dist name, value
  end

# iterate through every district in de_repo
  def collection_of_districts_and_growth(data_hash)
    districts = @de_repo.districts.reject do |district|
      district.statewide_test.nil?
    end



    all_districts_growth = districts.map do |district|
      # binding.pry
      district_growth_for_subject(district.name, data_hash)
    end
    binding.pry
    all_districts_growth
  end

  def district_growth_for_subject(name, data_hash)
    array = [name]
    # binding.pry
    no_nils = go_into_hash_and_eliminate_nils(name, data_hash)
    # binding.pry
    if !count_key_value_pairs(no_nils)
      array << nil
      # binding.pry
    else
      array << district_growth_values(no_nils, data_hash)
      # binding.pry
    end
    array
  end

  def go_into_hash_and_eliminate_nils(name, data_hash)
    grade_hash = grade_subject_converter(name)[data_hash[:grade]]
    minus_nils = grade_hash.reject do |year, sub_data|
      sub_data[data_hash[:subject]].nil?
      end
      minus_nils
  end

  def count_key_value_pairs(hash_without_nils)
    hash_without_nils.length >= 2
  end

  def district_growth_values(hash_without_nils, data_hash)
    year1 = hash_without_nils.keys.min
    year_last = hash_without_nils.keys.max
    min_val = hash_without_nils[year1][data_hash[:subject]]
    max_val = hash_without_nils[year_last][data_hash[:subject]]
    (max_val - min_val) / (year_last - year1)
  end

  # ((proficiency at year3) - (proficiency at year1)) / (year3 - year1).


  # :third_grade => {
  #   2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
  #   2013 => {:math => 0.855, :reading => 0.859, :writing => 0.6689},
  #   2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
  # },
  # :eighth_grade => {
  #   2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
  #   2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
  #   2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662}
  # },

  def grade_subject_converter(name)
    {
      3 => de_repo.find_by_name(name).statewide_test.third_grade,
      8 => de_repo.find_by_name(name).statewide_test.eighth_grade,
      :math => @math,
      :reading => @reading,
      :writing => @writing
    }
  end

  def truncate(float)
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
