require 'minitest'
require 'minitest/autorun'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_it_initializes_with_an_empty_enrollments_array
    e_repo = EnrollmentRepository.new
    expected =  []

    assert_equal expected, e_repo.enrollments
  end

  def test_it_creates_one_enrollment_from_the_parsed_data
    e_repo = EnrollmentRepository.new
    hash_lines = [{:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}]
    e_repo.create_enrollment(hash_lines)
    expected = 1

    assert_equal expected, e_repo.enrollments.count
  end

  def test_it_can_retrieve_name_from_enrollment_in_repository
    e_repo = EnrollmentRepository.new
    hash_lines = [{:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}]
    e_repo.create_enrollment(hash_lines)
    expected = "ACADEMY 20"

    assert_equal expected, e_repo.enrollments[0].name
  end

  def test_it_creates_two_enrollments_into_repository
    e_repo = EnrollmentRepository.new
    hash_lines = [{:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}, {:name => "COLORADO", :kindergarten_participation => {2012 => 0.3675, 2011 => 0.33356, 2014 => 0.26777}}]
    e_repo.create_enrollment(hash_lines)
    expected = 2

    assert_equal expected, e_repo.enrollments.count
  end

  def test_it_returns_nil_if_enrollements_is_empty
    e_repo = EnrollmentRepository.new

    assert_equal nil, e_repo.find_by_name("Zorg")
  end

  def test_it_returns_nil_if_enrollment_doesnt_exist
    e_repo = EnrollmentRepository.new
    hash_lines = [{:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}, {:name => "COLORADO", :kindergarten_participation => {2012 => 0.3675, 2011 => 0.33356, 2014 => 0.26777}}]
    e_repo.create_enrollment(hash_lines)

    assert_equal nil, e_repo.find_by_name("Zorg")
  end

  def test_it_returns_enrollment_name_for_enrollment_in_enrollments_repo
    e_repo = EnrollmentRepository.new
    hash_lines = [{:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}, {:name => "COLORADO", :kindergarten_participation => {2012 => 0.3675, 2011 => 0.33356, 2014 => 0.26777}}]
    e_repo.create_enrollment(hash_lines)
    expected = "COLORADO"

    assert_equal expected, e_repo.find_by_name("colorado").name
  end


end