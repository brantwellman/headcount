require_relative "../lib/economic_profile"
require 'minitest'
require 'minitest/autorun'
require 'pry'

class EconomicProfileTest < Minitest::Test

  def setup
    @data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
            :children_in_poverty => {2012 => 0.1845},
            :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
            :title_i => {2015 => 0.543},
            :name => "ACADEMY 20"
           }
         end

  def test_it_exists
    assert EconomicProfile
  end

  def test_an_object_is_an_instance_of_class
    result = EconomicProfile.new(@data)

    assert result.is_a?(EconomicProfile)
  end

  def test_it_creates_insatance_vars_on_initialization
    ep = EconomicProfile.new(@data)
    expected1 = {[2005, 2009] => 50000, [2008, 2014] => 60000}
    expected2 = {2012 => 0.1845}
    assert_equal expected1, ep.median_household_income
    assert_equal expected2, ep.children_in_poverty
  end

  def test_it_returns_estimated_median_household_income_in_year
    ep = EconomicProfile.new(@data)
    result1 = ep.estimated_median_household_income_in_year(2005)
    result2 = ep.estimated_median_household_income_in_year(2014)
    result3 = ep.estimated_median_household_income_in_year(2008)

    assert_equal 50000, result1
    assert_equal 60000, result2
    assert_equal 55000, result3
  end

  def test_it_throws_an_error_for_unknown_year_on_household_income_data
    ep = EconomicProfile.new(@data)

    assert_raises(UnknownDataError) {ep.estimated_median_household_income_in_year(2000)}
  end

  def test_it_returns_median_house_hold_income_average
    ep = EconomicProfile.new(@data)
    result1 = ep.median_household_income_average

    assert_equal 55000, result1
  end

  def test_returns_child_poverty_data_by_year
      ep = EconomicProfile.new(@data)
      result = ep.children_in_poverty_in_year(2012)

      assert_equal 0.184, result #truncate
      assert_raises(UnknownDataError) {ep.children_in_poverty_in_year(2000)}
    end

    def test_free_or_reduced_price_lunch_percentage
      ep = EconomicProfile.new(@data)
      result = ep.free_or_reduced_price_lunch_percentage_in_year(2014)

      assert_equal 0.023, result
      assert_raises(UnknownDataError) { ep.free_or_reduced_price_lunch_number_in_year(2000)}
    end

    def test_free_or_reduced_price_lunch_by_number
      ep = EconomicProfile.new(@data)
      result = ep.free_or_reduced_price_lunch_number_in_year(2014)

      assert_equal 100, result
      assert_raises(UnknownDataError) { ep.free_or_reduced_price_lunch_number_in_year(2000)}
    end

    def test_it_returns_title_i_in_year
      ep = EconomicProfile.new(@data)
      result = ep.title_i_in_year(2015)

      assert_equal 0.543, result
      assert_raises(UnknownDataError) { ep.title_i_in_year(2012) }
    end

end
