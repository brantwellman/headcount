require 'minitest'
require 'minitest/autorun'
require './lib/district'


class DistrictTest < Minitest::Test

  def test_that_it_initializes_with_a_mixed_case_name
    district = District.new({:name => "COLORADO", :year => 1999, :enrollment => 0.5867})
    expected = "COLORADO"

    assert_equal expected, district.name
  end

  def test_it_initializes_with_an_all_upcase_name
    district = District.new({:name => "ACADEMY 20", :year => 1999, :enrollment => 0.5867})
    expected = "ACADEMY 20"

    assert_equal expected, district.name
  end

  def test_it_initializes_with_an_all_downcase_name
    district = District.new({:name => "ACADEMY 20", :year => 1999, :enrollment => 0.5867})
    expected = "ACADEMY 20"

    assert_equal expected, district.name
  end

  def test_it_initializes_with_a_year
    district = District.new({:name => "COLORADO", :year => 1999, :enrollment => 0.5867})
    expected = 1999

    assert_equal expected, district.year
  end

  def test_it_initializes_with_an_enrollment
    district = District.new({:name => "COLORADO", :year => 1999, :enrollment => 0.5867})
    expected = 0.5867

    assert_equal expected, district.enrollment
  end

end
