require 'minitest'
require 'minitest/autorun'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_it_initializes_with_an_empty_district_array
    d_repo = DistrictRepository.new
    expected =  []

    assert_equal expected, d_repo.districts
  end

  # def test_it_creates_a_district_from_the_parsed_data
    # d_repo = DistrictRepository.new
    #
  # end

  # def test_it_creates_multiple_districts_from_the_parsed_data
  #
  # end

  # def test_it_returns_district_object
  #
  # end

  # def test_it_returns_nil_if_district_doesnt_exist
  #
  # end
end
