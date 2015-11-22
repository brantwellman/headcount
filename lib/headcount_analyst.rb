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
    end
    districts_corellations
    true_count = districts_corellations.count(true)
    (true_count / districts_corellations.count) > 0.7 ? true : false
  end
#
  def top_statewide_test_year_over_year_growth(data_hash)
    raise InsufficientInformationError.new("A grade must be provided to answer this question") if !data_hash.has_key?(:grade)
    raise UnknownDataError.new("#{data_hash[:grade]} is not a known grade") if ![3, 8].include?(data_hash[:grade])
    if data_hash.has_key?(:top)
      top_x_districts_year_over_year(data_hash)
    elsif data_hash.has_key?(:grade) && data_hash.has_key?(:subject) && !data_hash.has_key?(:top)
      single_top_district_year_over_year(data_hash)
    elsif data_hash.has_key?(:weighting)
      weighting_across_all_subjects(data_hash)
    else
      average_weighting_hash = {:weighting => {:math => 1/3.0, :reading => 1/3.0, :writing => 1/3.0}}
      weighted_data_hash = data_hash.merge(average_weighting_hash)
      weighting_across_all_subjects(weighted_data_hash)
    end
  end
#
  def weighting_across_all_subjects(data_hash)
    math_districts_and_growth = collection_of_districts_and_growth(data_hash.merge({subject: :math}))
    math_wtd_grwth_vals = multiply_growth_values_by_weight(data_hash[:weighting][:math], math_districts_and_growth)
    reading_districts_and_growth = collection_of_districts_and_growth(data_hash.merge({subject: :reading}))
    reading_wtd_grwth_vals = multiply_growth_values_by_weight(data_hash[:weighting][:reading], reading_districts_and_growth)
    writing_districts_and_growth = collection_of_districts_and_growth(data_hash.merge({subject: :writing}))
    writing_wtd_grwth_vals = multiply_growth_values_by_weight(data_hash[:weighting][:writing], writing_districts_and_growth)
    weighted_dist_scores = add_weighted_values_for_each_subject(math_wtd_grwth_vals, reading_wtd_grwth_vals, writing_wtd_grwth_vals)
    sorted_weighted = sort_all_districts_growth_collection(weighted_dist_scores)
    district_with_max_growth(sorted_weighted)
  end

  def add_weighted_values_for_each_subject(math_coll, reading_coll, writing_coll)
    result = {}
    math_coll.each do |name, value|
      result[name] = value
    end
    reading_coll.each do |name, value|
      result[name] ||= 0
      result[name] += value
    end
    writing_coll.each do |name, value|
      result[name] ||= 0
      result[name] += value
    end
    result.to_a
  end

  def multiply_growth_values_by_weight(weight_value, subject_districts_growth)
    weighted_values = subject_districts_growth.map do |name, dist_growth|
      [name, dist_growth * weight_value]
    end
    weighted_values
  end

  def top_x_districts_year_over_year(data_hash)
    all_districts_and_growth = collection_of_districts_and_growth(data_hash)
    sorted_dists_growth = sort_all_districts_growth_collection(all_districts_and_growth)
    number = data_hash[:top]
    top_dists = sorted_dists_growth.last(number)
    dists_trunced_growth = top_dists.map do |dist_growth|
      [dist_growth[0], truncate(dist_growth[-1])]
    end
    dists_trunced_growth.reverse
  end

  def single_top_district_year_over_year(data_hash)
    all_districts_and_growth = collection_of_districts_and_growth(data_hash)
    sorted_dists_growth = sort_all_districts_growth_collection(all_districts_and_growth)
    district_with_max_growth(sorted_dists_growth)
  end

  def district_with_max_growth(districts_growth_collection)
    max_growth = districts_growth_collection[-1]
    max_growth = [max_growth.first, truncate(max_growth[-1])]
  end

  def sort_all_districts_growth_collection(districts_growth)
    districts_growth.sort_by {|district_growth| district_growth[1] }
  end

  def collection_of_districts_and_growth(data_hash)
    districts = @de_repo.districts.reject do |district|
      district.statewide_test.nil?
    end
    all_districts_growth = districts.map do |district|
      district_growth_for_subject(district.name, data_hash)
    end
    all_districts_growth
  end

  def district_growth_for_subject(name, data_hash)
    array = [name]
    state_data = grade_subject_converter(name)[data_hash[:grade]]
    array << district_growth_values(state_data, data_hash)
  end

  def district_growth_values(hash, data_hash)
    years = hash.keys
    data = hash.values
    non_nil_data = data.map.each_with_index do |num, index|
      if num[data_hash[:subject]]
        [num[data_hash[:subject]], years[index]]
      end
    end.compact
    if count_key_value_pairs(non_nil_data)
      min_year = non_nil_data[0]
      max_year = non_nil_data[-1]
      (max_year[0] - min_year[0]) / (max_year[1] - min_year[1])
    else
      0.00000001
    end
  end

  def grade_subject_converter(name)
    {
      3 => de_repo.find_by_name(name).statewide_test.third_grade,
      8 => de_repo.find_by_name(name).statewide_test.eighth_grade,
    }
  end

  def count_key_value_pairs(hash_without_nils)
    hash_without_nils.length >= 2
  end

  def truncate(float)
    (float * 1000).floor / 1000.to_f
  end
end
