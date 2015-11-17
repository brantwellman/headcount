require 'minitest'
require 'minitest/autorun'
require_relative '../lib/statewidetest_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def setup
    @hash_line = {:name => "COLORADO", :third_grade => {
      2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
      2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
      2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
   },
   :eighth_grade => {
      2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
      2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
      2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662}
      }
    }
  end

  def test_it_initializes_with_an_empty_statewidetests_array
    str = StatewideTestRepository.new
    expected = []

    assert_equal expected, str.statewide_tests
  end

  def test_it_returns_nil_if_statewide_tests_is_empty
    str = StatewideTestRepository.new

    assert_equal nil, str.find_by_name("Zorg")
  end

  def test_it_returns_nil_if_statewide_test_doesnt_exist
    skip
    # need to figure out how to pass @key in to create new stw tests
    str = StatewideTestRepository.new
    str.create_statewide_tests(@hash_line)

    assert_equal nil, str.find_by_name("Zorg")
  end

  def test_it_returns_statewide_test_name_for_statewide_test_in_statewide_tests
    skip
    # need to figure out how to pass @key in to create new stw tests
    str = StatewideTestRepository.new
    str.create_statewide_tests(@hash_line)
    expected = "COLORADO"

    assert_equal expected, str.find_by_name("colorado").name
  end

end


#
#   def test_it_creates_one_enrollment_from_the_parsed_data
#     e_repo = EnrollmentRepository.new
#     hash_lines = [{:name => "ACADEMY 20", :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}]
#     e_repo.create_enrollments(hash_lines)
#     expected = 1
#
#     assert_equal expected, e_repo.enrollments.count
#   end
#
#   def test_it_can_retrieve_name_from_enrollment_in_repository
#     e_repo = EnrollmentRepository.new
#     hash_lines = [{:name => "ACADEMY 20", :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}]
#     e_repo.create_enrollments(hash_lines)
#     expected = "ACADEMY 20"
#
#     assert_equal expected, e_repo.enrollments[0].name
#   end
#
#   def test_it_creates_two_enrollments_into_repository
#     e_repo = EnrollmentRepository.new
#     hash_lines = [{:name => "ACADEMY 20", :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}, {:name => "COLORADO", :kindergarten => {2012 => 0.3675, 2011 => 0.33356, 2014 => 0.26777}}]
#     e_repo.create_enrollments(hash_lines)
#     expected = 2
#
#     assert_equal expected, e_repo.enrollments.count
#   end
#

#

#

#
#   def test_it_splits_file_hash_into_key_file_array
#     e_repo = EnrollmentRepository.new
#     hash = {
#     :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv",
#     :high_school_graduation => "./data/High school graduation rates.csv"
#   }
# }
#     expected = [[:kindergarten, "./data/Kindergartners in full-day program.csv"],
#                [:high_school_graduation, "./data/High school graduation rates.csv"]]
#
#     assert_equal expected, e_repo.peel_hash_to_key_file(hash)
#   end
#
#   def test_it_creates_an_enrollment_from_a_hashline
#     e_repo = EnrollmentRepository.new
#     hash_line = {:name => "ACADEMY 20", :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}
#     expected = 1
#     e_repo.create_enrollment(hash_line)
#     assert_equal expected, e_repo.enrollments.count
#   end
#
#   def test_it_combines_data_onto_an_already_existing_enrollment
#     e_repo = EnrollmentRepository.new
#     hash_line1 = {:name => "COLORADO", :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}
#     e_repo.create_enrollment(hash_line1)
#     hash_line2 = {:name => "COLORADO", :high_school_graduation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}
#     e_repo.create_enrollment(hash_line2)
#
#     expected1 = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
#     expected2 = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
#     assert_equal expected1, e_repo.enrollments[0].kindergarten
#     assert_equal expected2, e_repo.enrollments[0].high_school_graduation
#   end
# end
