require 'minitest'
require 'minitest/autorun'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment_repository'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def setup
    @d_repo = DistrictRepository.new
    @ha = HeadcountAnalyst.new(@d_repo)
    @d_repo.load_data({ :enrollment => {
                        :kindergarten => "./test/fixtures/kinder_enrollment_fixture.csv",
                        :high_school_graduation => "./test/fixtures/hs_grad_rates_fixture.csv" }})
  end

  def test_that_it_computes_enrollment_average_from_lcase_district
    dr = DistrictRepository.new
    er = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten => {
        2010 => 0.392,
        2011 => 0.353,
        2012 => 0.267
      }
    })
    er.add_records([e1])
    dr.load_repos({:enrollment => er})
    hda = HeadcountAnalyst.new(dr)
    expected=(0.392 + 0.353 + 0.267)/3

    assert_equal expected, hda.enrollment_average("Academy 20")
  end

  def test_that_it_computes_enrollment_average_from_upcase_district
    dr = DistrictRepository.new
    er = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten => {
        2010 => 0.392,
        2011 => 0.353,
        2012 => 0.267
      }
    })
    e2 = Enrollment.new({
      :name => "COLORADO",
      :kindergarten => {
        2010 => 0.392,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    er.add_records([e1, e2])
    dr.load_repos({:enrollment => er})
    hda = HeadcountAnalyst.new(dr)
    expected=(0.392 + 0.353 + 0.267)/3

    assert_equal expected, hda.enrollment_average("ACADEMY 20")
  end

  def test_it_computes_comparison_value_from_two_basic_averages_kind_enrollment
    expected = 0.766
    assert_equal expected, @ha.kindergarten_participation_rate_variation("Academy 20", :against => "Colorado")
  end

  def test_it_computes_comparison_value_from_two_complex_averages_kind_enrollment
    expected = 1.886
    assert_equal expected, @ha.kindergarten_participation_rate_variation("AGATE 300", :against => "Colorado")
  end

  def test_it_finds_kindergarten_participation_by_district_with_bad_data
    expected = {2007=>1.0, 2006=>nil}
    assert_equal expected, @ha.find_kindergarten_participation_by_year_for_district("Agate 300")
  end

  def test_it_variation_between_years_of_enrollment_info
    expected = {2007=>0.992, 2006=>1.051, 2005=>0.96, 2004=>1.258, 2008=>0.718, 2009=>0.652, 2010=>0.681, 2011=>0.728, 2012=>0.688, 2013=>0.694, 2014=>0.661}
    assert_equal expected, @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  end

  def test_that_it_computes_hs_grade_average_from_lcase_district
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten => {
        2010 => 0.392,
        2011 => 0.353,
        2012 => 0.267
      },
      :high_school_graduation => {
        2010 => 0.399,
        2011 => 0.323,
        2012 => 0.967
      }
      })
    e_repo.add_records([e1])
    d_repo.load_repos({:enrollment => e_repo})
    ha = HeadcountAnalyst.new(d_repo)
    expected = (0.399 + 0.323 + 0.967)/3

    assert_equal expected, ha.hs_graduation_average("Academy 20")
  end

  def test_that_it_computes_hs_grade_average_from_upcase_district
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "COLORADO",
      :kindergarten => {
        2010 => 0.392,
        2011 => 0.353,
        2012 => 0.267
      },
      :high_school_graduation => {
        2010 => 0.399,
        2011 => 0.323,
        2012 => 0.967
      }
      })
    e_repo.add_records([e1])
    d_repo.load_repos({:enrollment => e_repo})
    ha = HeadcountAnalyst.new(d_repo)
    expected = (0.399 + 0.323 + 0.967)/3

    assert_equal expected, ha.hs_graduation_average("COLORADO")
  end

  def test_it_computes_comparison_value_from_two_basic_averages_hs_grad_rate
    expected = 1.194
    assert_equal expected, @ha.high_school_graduation_rate_variation("ACADEMY 20", "Colorado")
  end

  def test_it_returns_correlation_value_for_hs_grad_rates_and_kind_part_rates
    expected = 3.945
    assert_equal expected, @ha.kindergarten_participation_against_high_school_graduation("Agate 300")
  end

  def test_it_returns_false_for_hs_kinder_part_correlation_between_values
    refute @ha.kindergarten_participation_against_high_school_graduation_correlation_window(for: "AGATE 300")
  end

  def test_it_returns_true_for_hs_kinder_part_correlation_between_values
    assert @ha.kindergarten_participation_against_high_school_graduation_correlation_window(for: "ACADEMY 20")
  end

  def test_it_returns_false_if_more_than_70percent_districts_show_correlation
    refute @ha.statewide_correlation_hs_kinder_across_districts
  end

  def test_it_returns_false_if_more_than_70percent_of_subset_of_districts_show_correlation
    districts_array_hash = {:across => ["AGATE 300", "ACADEMY 20", "BOULDER VALLEY RE 2"]}
    refute @ha.subset_of_districs_hs_kinder_across_districts(districts_array_hash)
  end

  def test_it_returns_true_if_more_than_70percent_of_subset_of_districts_show_correlation
    districts_array_hash = {:across => ["PAWNEE RE-12", "ACADEMY 20", "BOULDER VALLEY RE 2"]}
    assert @ha.subset_of_districs_hs_kinder_across_districts(districts_array_hash)
  end

  def test_feature_participation_feature_key_across
    districts_array_hash = {:across => ["PAWNEE RE-12", "ACADEMY 20", "BOULDER VALLEY RE 2"]}

    assert @ha.kindergarten_participation_correlates_with_high_school_graduation(districts_array_hash)
  end

  def test_feature_participation_feature_key_for_and_includes_colorado
    districts_array_hash = {:for => "COLORADO"}
    refute @ha.kindergarten_participation_correlates_with_high_school_graduation(districts_array_hash)
  end

  def test_feature_participation_feature_true_key_for_and_not_colorado
    districts_array_hash = {:for => "ACADEMY 20"}
    assert @ha.kindergarten_participation_correlates_with_high_school_graduation(districts_array_hash)
  end

  def test_feature_participation_feature_false_key_for_and_not_colorado
    districts_array_hash = {:for => "AGATE 300"}
    refute @ha.kindergarten_participation_correlates_with_high_school_graduation(districts_array_hash)
  end
end
