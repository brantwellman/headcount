require_relative "../lib/economic_profile_repository"
require 'minitest'
require 'minitest/autorun'
require 'pry'

class EconomicProfileRepositoryTest < Minitest::Test

  def setup
    @big_data_hash = {
    :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
    :title_i => "./data/Title I students.csv"
    }
  }
  end

  def test_it_exists

    assert EconomicProfileRepository
  end

  def test_an_object_is_an_instance_of_class
    result = EconomicProfileRepository.new

    assert result.is_a?(EconomicProfileRepository)
  end

  def test_it_initializes_with_an_empty_ep_repo
    epr = EconomicProfileRepository.new

    assert_equal [], epr.economic_profiles
  end

  def test_load_data_makes_profile_objects_and_stores_them_in_repo
    epr = EconomicProfileRepository.new
    epr.load_data(@big_data_hash)

    assert_equal 181, epr.economic_profiles.count
  end

  def test_can_find_by_name
    epr = EconomicProfileRepository.new
    epr.load_data(@big_data_hash)

    assert_equal "ACADEMY 20", epr.find_by_name("ACADEMY 20").name
    assert_equal "AGATE 300", epr.find_by_name("AGATE 300").name
  end
end
