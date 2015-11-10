require 'minitest'
require 'minitest/autorun'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_it_initializes_with_an_empty_district_array
    d_repo = DistrictRepository.new
    expected =  []

    assert_equal expected, d_repo.districts
  end

  def test_it_creates_one_district_from_the_parsed_data
    d_repo = DistrictRepository.new
    hash_lines = [{:name=>"COLORADO", :year=>2012, :enrollment=>0.695}]
    d_repo.create_districts(hash_lines)
    expected = 1

    assert_equal expected, d_repo.districts.count
  end

  def test_it_can_retrieve_name_from_district_in_repository
    d_repo = DistrictRepository.new
    hash_lines = [{:name=>"COLORADO", :year=>2012, :enrollment=>0.695}]
    d_repo.create_districts(hash_lines)
    expected = "COLORADO"

    assert_equal expected, d_repo.districts[0].name
  end

  def test_it_creates_two_districts_into_repository
    d_repo = DistrictRepository.new
    hash_lines = [{:name=>"COLORADO", :year=>2012, :enrollment=>0.695}, {:name=>"ACADEMY 20", :year=>2008, :enrollment=>0.38456}]
    d_repo.create_districts(hash_lines)
    expected = 2

    assert_equal expected, d_repo.districts.count
  end

  def test_it_returns_nil_if_districts_is_empty
    d_repo = DistrictRepository.new

    assert_equal nil, d_repo.find_by_name("Zorg")
  end

  def test_it_returns_nil_if_district_doesnt_exist
    d_repo = DistrictRepository.new
    hash_lines = [{:name=>"COLORADO", :year=>2012, :enrollment=>0.695}, {:name=>"ACADEMY 20", :year=>2008, :enrollment=>0.38456}]
    d_repo.create_districts(hash_lines)

    assert_equal nil, d_repo.find_by_name("Zorg")
  end

  def test_it_returns_district_name_for_district_in_districts_repo
    d_repo = DistrictRepository.new
    hash_lines = [{:name=>"COLORADO", :year=>2012, :enrollment=>0.695}]
    d_repo.create_districts(hash_lines)
    expected = "COLORADO"

    assert_equal expected, d_repo.find_by_name("colorado").name
  end

  def test_it_returns_empty_array_for_no_matches
    d_repo = DistrictRepository.new

    assert_equal [], d_repo.find_all_matching("co")
  end

  def test_it_returns_nil_if_district_doesnt_exist
    d_repo = DistrictRepository.new
    hash_lines = [{:name=>"COLORADO", :year=>2012, :enrollment=>0.695}, {:name=>"ACADEMY 20", :year=>2008, :enrollment=>0.38456}]
    d_repo.create_districts(hash_lines)

    assert_equal [], d_repo.find_all_matching("Zorg")
  end

  def test_it_returns_district_name_for_district_in_districts_repo
    d_repo = DistrictRepository.new
    hash_lines = [{:name=>"COLORADO", :year=>2012, :enrollment=>0.695}]
    d_repo.create_districts(hash_lines)
    expected = d_repo.districts[0].name

    assert_equal expected, d_repo.find_all_matching("color")[0].name
    assert_equal 1, d_repo.find_all_matching("color").count
  end

  def test_it_returns_district_names_for_multiple_matches_in_repo
    d_repo = DistrictRepository.new
    hash_lines = [{:name=>"ACADEMY 10", :year=>2012, :enrollment=>0.695}, {:name=>"ADAMS COUNTY", :year=>2012, :enrollment=>0.695}, {:name=>"ZORG", :year=>2012, :enrollment=>0.695}]
    d_repo.create_districts(hash_lines)
    expected = 2

    assert_equal expected, d_repo.find_all_matching("ad").count
  end
  # inflate tests when stuck or bored
end


#[{:name=>"colorado", :year=>2012, :enrollment=>0.695}, {:name=>"colorado", :year=>2013, :enrollment=>0.70263}, {:name=>"colorado", :year=>2014, :enrollment=>0.74118}, {:name=>"academy 20", :year=>2007, :enrollment=>0.39159}, {:name=>"academy 20", :year=>2006, :enrollment=>0.35364}, {:name=>"academy 20", :year=>2005, :enrollment=>0.26709}, {:name=>"academy 20", :year=>2004, :enrollment=>0.30201}, {:name=>"academy 20", :year=>2008, :enrollment=>0.38456}]
