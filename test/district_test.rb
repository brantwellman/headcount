require 'minitest'
require 'minitest/autorun'
require './lib/district'


class DistrictTest < Minitest::Test

  def test_that_it_initializes_with_a_name
    district = District.new({:name => "COLORADO"})
    expected = "COLORADO"

    assert_equal expected, district.name
  end

  def test_it_has_access_to_the_enrollment
    skip
  end
  
end
