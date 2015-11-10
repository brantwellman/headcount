require 'minitest'
require 'minitest/autorun'
require './lib/district'


class DistrictTest < Minitest::Test

  def test_that_it_initializes_with_a_mixed_case_name
    district = District.new({:name => "Colorado"})
    expected = "colorado"

    assert_equal expected, district.name
  end

  def test_it_initializes_with_an_all_upcase_name
    district = District.new({:name => "ACADEMY 20"})
    expected = "academy 20"

    assert_equal expected, district.name
  end

  def test_it_initializes_with_an_all_downcase_name
    district = District.new({:name => "academy 20"})
    expected = "academy 20"

    assert_equal expected, district.name
  end
end
