require 'minitest'
require 'minitest/autorun'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment_repository'
require_relative '../lib/insufficient_information_error'
require_relative '../lib/unknown_data_error'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def setup
    @d_repo = DistrictRepository.new
    @ha = HeadcountAnalyst.new(@d_repo)
    @d_repo.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kinder_enrollment_fixture.csv",
        :high_school_graduation => "./test/fixtures/hs_grad_rates_fixture.csv" },
      :statewide_testing => {
        :third_grade => "./test/fixtures/3rd_grade_nil_fixture.csv"
      }
    })
  end

  def test_that_it_computes_enrollment_average_from_lcase_district
    dr = DistrictRepository.new
    er = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => {
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
      :kindergarten_participation => {
        2010 => 0.392,
        2011 => 0.353,
        2012 => 0.267
      }
    })
    e2 = Enrollment.new({
      :name => "COLORADO",
      :kindergarten_participation => {
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
    assert_equal expected, @ha.kinder_part_rate_variation("Academy 20", :against => "Colorado")
  end

  def test_it_computes_comparison_value_from_two_complex_averages_kind_enrollment
    expected = 1.885
    assert_equal expected, @ha.kinder_part_rate_variation("AGATE 300", :against => "Colorado")
  end

  def test_it_finds_kindergarten_participation_by_district_with_bad_data
    expected = {2007=>1.0, 2006=>nil}
    assert_equal expected, @ha.find_kinder_part_by_year_for_district("Agate 300")
  end

  def test_it_variation_between_years_of_enrollment_info
    expected = {2007=>0.992, 2006=>1.05, 2005=>0.96, 2004=>1.257, 2008=>0.717, 2009=>0.652, 2010=>0.681, 2011=>0.727, 2012=>0.688, 2013=>0.694, 2014=>0.661}

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
    expected = 1.195
    assert_equal expected, @ha.high_school_graduation_rate_variation("ACADEMY 20", "Colorado")
  end

  def test_it_returns_correlation_value_for_hs_grad_rates_and_kind_part_rates
    expected = 3.943
    assert_equal expected, @ha.kindergarten_participation_against_high_school_graduation("Agate 300")
  end

  def test_it_returns_false_for_hs_kinder_part_correlation_between_values
    refute @ha.kinder_part_vs_high_school_grad_correlation_window(for: "AGATE 300")
  end

  def test_it_returns_true_for_hs_kinder_part_correlation_between_values
    assert @ha.kinder_part_vs_high_school_grad_correlation_window(for: "ACADEMY 20")
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



  def test_it_sorts_array_collection_by_growth
    districts_growth = [["COLORADO", 0.0030000000000000027],
                        ["ACADEMY 20", -0.03300000000000003],
                        ["ADAMS COUNTY 14", -0.008000000000000007]]
    expected =         [["ACADEMY 20", -0.03300000000000003],
                        ["ADAMS COUNTY 14", -0.008000000000000007],
                        ["COLORADO", 0.0030000000000000027]]
    assert_equal expected, @ha.sort_all_districts_growth_collection(districts_growth)
  end

  def test_is_throws_error_if_unknown_grade_is_provided
    assert_raises(UnknownDataError) { @ha.top_statewide_test_year_over_year_growth(grade: 9, subject: :math) }
  end

  def test_it_throws_error_if_grade_key_is_not_included_for_growth_rates
    assert_raises(InsufficientInformationError) { @ha.top_statewide_test_year_over_year_growth(subject: :math) }
  end

  def test_returns_true_for_hash_with_greater_than_2_key_value_pairs
    no_nils_hash = {
      2008 => {
        :math => 0.857,
        :reading => 0.866,
        :writing => 0.671
      },
      2009 => {
        :math => 0.824,
        :reading => 0.862,
        :writing => 0.706
      },
      2010 => {
        :math => 0.877,
        :reading => 0.862,
        :writing => 0.706
        }
      }
    assert @ha.count_key_value_pairs(no_nils_hash)
  end

  def test_returns_true_for_hash_with_2_key_value_pairs
    no_nils_hash = {
      2008 => {
        :math => 0.857,
        :reading => 0.866,
        :writing => 0.671
      },
      2009 => {
        :math => 0.824,
        :reading => 0.862,
        :writing => 0.706
      }
    }
    assert @ha.count_key_value_pairs(no_nils_hash)
  end

  def test_returns_false_for_hash_with_less_than_2_key_value_pairs
    no_nils_hash = {
      2008 => {
        :math => 0.857,
        :reading => 0.866,
        :writing => 0.671
      }
    }
    refute @ha.count_key_value_pairs(no_nils_hash)
  end

  def test_it_removes_nils_from_grade_data
    expected = {
      2008 => {
        :math => 0.857,
        :reading => 0.866,
        :writing => 0.671
      },
      2009 => {
        :math => 0.824,
        :reading => 0.862,
        :writing => 0.706
        }
      }
    assert_equal expected, @ha.go_into_hash_and_eliminate_nils("ACADEMY 20", {grade: 3, subject: :math})
  end

  def test_it_returns_value_from_grade_subject_converter
    expected = {
      3 => {
        2008 => {
          :math => 0.857,
          :reading => 0.866,
          :writing => 0.671
          },
        2009 => {
          :math => 0.824,
          :reading => 0.862,
          :writing => 0.706
          },
        2010 => {
          :math => nil,
          :reading => 0.864,
          :writing => 0.662
          },
        2011 => {
          :math => nil
          }
        },
        8 => nil}

    assert_equal expected, @ha.grade_subject_converter("ACADEMY 20")
  end

  def test_it_returns_a_growth_value_for_district
    hash_without_nils = {
      2008 => {
        :math => 0.857,
        :reading => 0.866,
        :writing => 0.671
      },
      2009 => {
        :math => 0.824,
        :reading => 0.862,
        :writing => 0.706
        }
      }
    data_hash = { grade: 3, subject: :math }
    expected = -0.03300000000000003
    assert_equal expected, @ha.district_growth_values(hash_without_nils, data_hash)
  end

  def test_it_creates_growth_district_array
    expected = ["ACADEMY 20", -0.03300000000000003]
    assert_equal expected, @ha.district_growth_for_subject("ACADEMY 20", {grade: 3, subject: :math})
  end

  def test_it_creates_array_with_all_districts_and_growths
    expected = [["COLORADO", 0.0030000000000000027], ["ACADEMY 20", -0.03300000000000003], ["ADAMS COUNTY 14", -0.008000000000000007]]
    assert_equal expected, @ha.collection_of_districts_and_growth({grade: 3, subject: :math})
  end

  def test_it_pulls_district_array_with_top_growth_rate_and_truncates_growth_rate
    sorted_dists = [["ACADEMY 20", -0.03300000000000003],
                    ["ADAMS COUNTY 14", -0.008000000000000007],
                    ["COLORADO", 0.0030000000000000027]]
    expected = ["COLORADO", 0.003]
    assert_equal  expected, @ha.single_top_district_year_over_year(sorted_dists)
  end

  # def top_x_districts_year_over_year(num, sorted_dists_growth_array)
  def test_it_returns_top_x_districts_year_over_year_from_sorted_array
    sorted_dists = [["ACADEMY 20", -0.03300000000000003],
                    ["ADAMS COUNTY 14", -0.008000000000000007],
                    ["COLORADO", 0.0030000000000000027],
                    ["AGATE", 0.0046000000000008],
                    ["BOULDER VALLEY", 0.005678900]]
    expected = [["BOULDER VALLEY", 0.005], ["AGATE", 0.004], ["COLORADO", 0.003]]
    assert_equal expected, @ha.top_x_districts_year_over_year(3, sorted_dists)
  end

  def test_it_muliplies_each_growth_value_by_the_weight
    subject_districts_growth = [["ACADEMY 20", -0.03300000000000003],
                                ["ADAMS COUNTY 14", -0.008000000000000007],
                                ["COLORADO", 0.0030000000000000027],
                                ["AGATE", 0.0046000000000008],
                                ["BOULDER VALLEY", 0.005678900]]
    weight_value = 1/3.0
    expected = [["ACADEMY 20", -0.01100000000000001],
                ["ADAMS COUNTY 14", -0.0026666666666666687],
                ["COLORADO", 0.0010000000000000009],
                ["AGATE", 0.0015333333333335999],
                ["BOULDER VALLEY", 0.0018929666666666666]]
    assert_equal expected, @ha.multiply_growth_values_by_weight(weight_value, subject_districts_growth)
  end
end
