require 'minitest'
require 'minitest/autorun'
require './lib/headcount_analyst'
require './lib/district_repository'
require './lib/enrollment_repository'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def test_that_it_computes_enrollment_average_from_lcase_district
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => {
        2010 => 0.392,
        2011 => 0.353,
        2012 => 0.267
      }
    })
    e_repo.add_records([e1])
    d_repo.load_repos({:enrollment => e_repo})
    ha = HeadcountAnalyst.new(d_repo)
    expected=(0.392 + 0.353 + 0.267)/3

    assert_equal expected, ha.enrollment_average("Academy 20")
  end

  def test_that_it_computes_enrollment_average_from_upcase_district
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => {
        2010 => 0.392,
        2011 => 0.353,
        2012 => 0.267
      }
    })
    e2 = Enrollment.new({
      :name => "Colorado",
      :kindergarten_participation => {
        2010 => 0.392,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    e_repo.add_records([e1, e2])
    d_repo.load_repos({:enrollment => e_repo})
    ha = HeadcountAnalyst.new(d_repo)
    expected=(0.392 + 0.353 + 0.267)/3

    assert_equal expected, ha.enrollment_average("ACADEMY 20")
  end

  def test_it_computes_comparison_value_from_two_basic_averages
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => {
        2010 => 1.0,
        2011 => 1.0,
        2012 => 1.0
      }
    })
    e2 = Enrollment.new({
      :name => "Colorado",
      :kindergarten_participation => {
        2010 => 2.0,
        2011 => 2.0,
        2012 => 2.0
      }
    })
    e_repo.add_records([e1, e2])
    d_repo.load_repos({:enrollment => e_repo})
    ha = HeadcountAnalyst.new(d_repo)
    expected = 0.5

    assert_equal expected, ha.kindergarten_participation_rate_variation("ACADEMY 20", :against => "Colorado")
  end

  def test_it_computes_comparison_value_from_two_complex_averages
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "Adams 20",
      :kindergarten_participation => {
        2010 => 0.567,
        2011 => 0.675,
        2012 => 0.876
      }
    })
    e2 = Enrollment.new({
      :name => "Colorado",
      :kindergarten_participation => {
        2010 => 0.9,
        2011 => 0.0,
        2012 => 0.456
      }
    })
    e_repo.add_records([e1, e2])
    d_repo.load_repos({:enrollment => e_repo})
    ha = HeadcountAnalyst.new(d_repo)
    expected = 1.562

    assert_equal expected, ha.kindergarten_participation_rate_variation("Adams 20", :against => "Colorado")
  end

  def test_it_finds_kindergarten_participation_by_district
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "Adams 20",
      :kindergarten_participation => {
        2010 => 0.567,
        2011 => 0.675,
        2012 => 0.876
      }
    })
    e2 = Enrollment.new({
      :name => "Colorado",
      :kindergarten_participation => {
        2010 => 0.9,
        2011 => 0.0,
        2012 => 0.456
      }
    })
    e_repo.add_records([e1, e2])
    d_repo.load_repos({:enrollment => e_repo})
    ha = HeadcountAnalyst.new(d_repo)

    expected = {
      2010 => 0.567,
      2011 => 0.675,
      2012 => 0.876
    }


    assert_equal expected, ha.find_kindergarten_participation_by_year_for_district("Adams 20")
  end

  def test_it_variation_between_years_of_enrollment_info
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ADAMS 20",
      :kindergarten_participation => {
        2010 => 0.567,
        2011 => 0.675,
        2012 => 0.876
      }
    })
    e2 = Enrollment.new({
      :name => "COLORADO",
      :kindergarten_participation => {
        2010 => 0.9,
        2011 => 0.345,
        2012 => 0.456
      }
    })
    e_repo.add_records([e1, e2])
    d_repo.load_repos({:enrollment => e_repo})
    ha = HeadcountAnalyst.new(d_repo)

    expected = {
      2010 => 0.63,
      2011 => 1.957,
      2012 => 1.921
    }

    assert_equal expected, ha.kindergarten_participation_rate_variation_trend('ADAMS 20', :against => 'COLORADO')
  end
end
