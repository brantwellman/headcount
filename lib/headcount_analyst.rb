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
    raise InsufficientInformationError.new("A grade must be provided to answer this question") if !data_hash.has_key?(:grade)
    raise UnknownDataError.new("#{data_hash[:grade]} is not a known grade") if ![3, 8].include?(data_hash[:grade])
#   call collection_of_districts_and_growth
    all_districts_and_growth = collection_of_districts_and_growth(data_hash)
    # sort all_districts_and_growth by second element
    sorted_dists_growth = sort_all_districts_growth_collection(all_districts_and_growth)
    # truncate return values
    # if weighting
    #   do something
    # elsif top
    #   do something
    elsif data_hash.has_key?(:grade) && data_hash.has_key?(:subject) && !data_hash.has_key?(:top)
            #     ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
            # => ['the top district name', 0.123]
            max_growth = sorted_dists_growth[-1]
            max_growth = [max_growth[0], truncate(max_growth[-1])
    #  do something
    # else (grade only)
    #  do something
    # end
  end

# tested(1)
  def sort_all_districts_growth_collection(districts_growth)
    districts_growth.sort_by {|district_growth| district_growth[1] }
  end

# tested(1)
# iterate through every district in de_repo and collect districts and their growth
  def collection_of_districts_and_growth(data_hash)
    districts = @de_repo.districts.reject do |district|
      district.statewide_test.nil?
    end
    all_districts_growth = districts.map do |district|
      district_growth_for_subject(district.name, data_hash)
    end
    all_districts_growth
  end
# tested(1)
  def district_growth_for_subject(name, data_hash)
    array = [name]
    no_nils = go_into_hash_and_eliminate_nils(name, data_hash)
    if !count_key_value_pairs(no_nils)
      array << nil
    else
      array << district_growth_values(no_nils, data_hash)
    end
    array
  end
# tested(1)
  def go_into_hash_and_eliminate_nils(name, data_hash)
    grade_hash = grade_subject_converter(name)[data_hash[:grade]]
    minus_nils = grade_hash.reject do |year, sub_data|
      sub_data[data_hash[:subject]].nil?
      end
    minus_nils
  end
# test (3)
  def count_key_value_pairs(hash_without_nils)
    hash_without_nils.length >= 2
  end
# test (1)
  def district_growth_values(hash_without_nils, data_hash)
    year1 = hash_without_nils.keys.min
    year_last = hash_without_nils.keys.max
    min_val = hash_without_nils[year1][data_hash[:subject]]
    max_val = hash_without_nils[year_last][data_hash[:subject]]
    (max_val - min_val) / (year_last - year1)
  end

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
# test(1)
  def grade_subject_converter(name)
    {
      3 => de_repo.find_by_name(name).statewide_test.third_grade,
      8 => de_repo.find_by_name(name).statewide_test.eighth_grade,
      # :math => @math,
      # :reading => @reading,
      # :writing => @writing
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
