require 'minitest'
require 'minitest/autorun'
require './lib/statewidetest'

class StatewideTestTest < Minitest::Test

  def setup
    @data_line = {:name => "COLORADO"}
  end

  def test_it_initializes_with_a_name
    statey = StatewideTest.new(@data_line)

    assert_equal "COLORADO", statey.name
  end

  def test_it_initializes_with_an_empty_data_hash
    statey = StatewideTest.new(@data_line)
    expected = {}
    assert_equal expected, statey.data
  end
end

#
#   def test_it_initializes_with_a_kindergarten_participation_hash
#     enroll = Enrollment.new({:name => "COLORADO", :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
#     expected = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
#
#     assert_equal expected, enroll.kindergarten
#   end
#
#   def test_it_returns_the_enrollment_participation_by_year_with_rounded_floats
#     enroll = Enrollment.new({:name => "COLORADO", :kindergarten => {2010 => 0.392, 2011 => 0.354, 2012 => 0.268}})
#     expected = {2010 => 0.392, 2011 => 0.354, 2012 => 0.268}
#
#     assert_equal expected, enroll.kindergarten_participation_by_year
#   end
#
#   def test_it_returns_the_enrollment_for_a_specfic_year_as_rounded_float
#     enroll = Enrollment.new({:name => "COLORADO", :kindergarten => {2010 => 0.392, 2011 => 0.354, 2012 => 0.268}})
#     expected = 0.392
#
#     assert_equal expected, enroll.kindergarten_participation_in_year(2010)
#   end
#
#   def test_it_returns_the_enrollment_for_a_specfic_year_as_rounded_float_from_2_digit_float
#     enroll = Enrollment.new({:name => "COLORADO", :kindergarten => {2010 => 0.39, 2011 => 0.35356, 2012 => 0.2677}})
#     expected = 0.39
#
#     assert_equal expected, enroll.kindergarten_participation_in_year(2010)
#   end
#
#   def test_it_returns_nil_for_an_unknown_enrollment_year
#     enroll = Enrollment.new({:name => "COLORADO", :kindergarten => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
#     expected = nil
#
#     assert_equal expected, enroll.kindergarten_participation_in_year(2015)
#   end
#
#   def test_it_can_access_enrollment_data_by_year
#     enroll = Enrollment.new({:name => "COLORADO", :kindergarten => {2010 => 0.392, 2011 => 0.354, 2012 => 0.268}, :high_school_graduation => {2010 => 0.392, 2011 => 0.354, 2012 => 0.268}})
#     expected = {2010 => 0.392, 2011 => 0.354, 2012 => 0.268}
#
#     assert_equal expected, enroll.high_school_graduation
#   end
#
#   def test_it_returns_nil_for_an_unknown_graduation_year
#     enroll = Enrollment.new({:name => "COLORADO", :kindergarten => {2010 => 0.392, 2011 => 0.354, 2012 => 0.268}, :high_school_graduation => {2000 => 0.392, 2999 => 0.354, 2888 => 0.268}})
#     expected = nil
#
#     assert_equal expected, enroll.graduation_rate_in_year(2015)
#   end
#
#   def test_it_returns_the_hs_graduation_rate_for_a_specfic_year_as_rounded_float
#     enroll = Enrollment.new({:name => "COLORADO", :kindergarten => {2010 => 0.392, 2011 => 0.354, 2012 => 0.268}, :high_school_graduation => {2000 => 0.392, 2999 => 0.354, 2888 => 0.268}})
#     expected = 0.268
#
#     assert_equal expected, enroll.graduation_rate_in_year(2888)
#   end
#
#   def test_it_returns_the_hs_grad_rate_for_a_specfic_year_as_rounded_float_from_2_digit_float
#     enroll = Enrollment.new({:name => "COLORADO", :kindergarten => {2010 => 0.392, 2011 => 0.354, 2012 => 0.268}, :high_school_graduation => {2000 => 0.392, 2999 => 0.354, 2888 => 0.26}})
#     expected = 0.26
#
#     assert_equal expected, enroll.graduation_rate_in_year(2888)
#   end
# end
