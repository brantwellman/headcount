require 'minitest'
require 'minitest/autorun'
require_relative '../lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def setup
    @input_hash = {
      :enrollment => {
        :kindergarten => "./test/fixtures/kinder_one_district.csv",
        :high_school_graduation => "./test/fixtures/high_school_one_district.csv",
      },
      :statewide_testing => {
        :third_grade =>  "./test/fixtures/3rd_grade_one_district.csv",
        :eighth_grade => "./test/fixtures/eighth grade enrollment data.csv",
        :math => "./test/fixtures/math.csv",
        :reading => "./test/fixtures/reading.csv",
        :writing => "./test/fixtures/writing.csv"
      }
    }
  end

  def test_it_initializes_with_an_empty_districts_array
    d_repo = DistrictRepository.new
    expected =  []

    assert_equal expected, d_repo.districts
  end

  def test_it_initializes_with_an_empty_enrollment_repository
    d_repo = DistrictRepository.new
    result = d_repo.enrollment_repository.enrollments

    assert_equal [], result
  end

  def test_it_initializes_with_an_empty_sw_repository
    d_repo = DistrictRepository.new
    result = d_repo.statewidetest_repository.statewide_tests

    assert_equal [], result
  end

  def test_its_loads_repositories
    dr = DistrictRepository.new
    dr.load_data(@input_hash)

    assert_equal 3, dr.districts.count
  end

  def test_it_creates_enrollment_objects_through_load_data
    dr = DistrictRepository.new
    dr.load_data(@input_hash)
    result = dr.enrollment_repository.enrollments.count

    assert_equal  2, result
  end

  def test_it_creates_statewide_test_objects_through_load_data
    dr = DistrictRepository.new
    dr.load_data(@input_hash)
    result = dr.statewidetest_repository.statewide_tests.count

    assert_equal  2, result
  end

  def test_it_has_access_to_enrollment_repo_objects_after_data_load_kinder_data
    dr = DistrictRepository.new
    dr.load_data(@input_hash)
    result = dr.enrollment_repository.find_by_name("ACADEMY 20")
    result1 = result.name
    result2 = result.kindergarten_participation_by_year
    expected1 = "ACADEMY 20"
    expected2 = {2007=>0.391, 2006=>0.353, 2005=>0.267, 2004=>0.302, 2008=>0.384, 2009=>0.39, 2010=>0.436, 2011=>0.489, 2012=>0.478, 2013=>0.487, 2014=>0.49}

    assert_equal expected1, result1
    assert_equal expected2, result2
  end

  def test_it_has_access_to_enrollment_repo_objects_after_data_load_high_school_data
    dr = DistrictRepository.new
    dr.load_data(@input_hash)
    result = dr.enrollment_repository.find_by_name("ADAMS COUNTY 14")
    result1 = result.name
    result2 = result.graduation_rate_by_year
    expected1 = "ADAMS COUNTY 14"
    expected2 = {2010=>0.57, 2011=>0.608, 2012=>0.633, 2013=>0.593, 2014=>0.659}

    assert_equal expected1, result1
    assert_equal expected2, result2
  end

  def test_it_has_access_to_statewide_testing_objects_after_data_load
    dr = DistrictRepository.new
    dr.load_data(@input_hash)
    result = dr.statewidetest_repository.find_by_name("ACADEMY 20")
    result1 = result.class
    result2 = result.name
    expected1 = StatewideTest
    expected2 = "ACADEMY 20"

    assert_equal expected1, result1
    assert_equal expected2, result2
  end

  def test_it_finds_by_name
    dr = DistrictRepository.new
    dr.load_data(@input_hash)
    result = dr.find_by_name("ACADEMY 20")

    assert_equal District, result.class
    assert_equal "ACADEMY 20", result.name
  end

  def test_it_returns_an_array_with_one_matching_district_name
    dr = DistrictRepository.new
    dr.load_data(@input_hash)
    result = dr.find_all_matching("ACA")[0].name
    expected = "ACADEMY 20"

    assert_equal expected, result
  end

  def test_it_returns_an_array_with_multiple_matches
    dr = DistrictRepository.new
    dr.load_data(@input_hash)
    result = dr.find_all_matching("A").map {|district| district.name}
    expected = ["ACADEMY 20", "ADAMS COUNTY 14", "AGATE 300"]

    assert_equal expected, result
  end


  # dr.enrollment_repository
  # dr.statewidetest_repository
  # dr.find_by_name
  # Need to test for district ob by name
  # test has enrollment date
  #   kindergarten
  #   high_school
  # test has statewidetest data
  #   third grade
  #   eighth grade
  #   math
  #   reading
  #   writing
  # check that enrollment repo has objects
  # test that statewide test repo has objects
  # test that district collection has objects


end
