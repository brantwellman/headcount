require 'minitest'
require 'minitest/autorun'
require './lib/statewidetest'

class StatewideTestTest < Minitest::Test

  def setup
    @data_line = {:name => "COLORADO", :third_grade => {
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

  def test_it_initializes_with_a_name
    statey = StatewideTest.new(@data_line)
    assert_equal "COLORADO", statey.name
  end

  def test_it_stores_a_third_grade_hash
    statey = StatewideTest.new(@data_line)
    expected = {
      2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
      2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
      2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
   }
    assert_equal expected, statey.third_grade
  end

  def test_it_stores_an_eigth_grade_hash
    statey = StatewideTest.new(@data_line)
    expected = {
      2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
      2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
      2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662}
      }
    assert_equal expected, statey.eighth_grade
  end

  # def test_it_stores_a_math_hash
  #   statey = StatewideTest.new(@data_line)
  #   expected = {
  #
  #     }
  #   assert_equal expected, statey.math
  # end
  #
  # def test_it_stores_an_reading_hash
  #   statey = StatewideTest.new(@data_line)
  #   expected = {
  #
  #     }
  #   assert_equal expected, statey.reading
  # end
  #
  # def test_it_stores_an_writing_hash
  #   statey = StatewideTest.new(@data_line)
  #   expected = {
  #
  #     }
  #   assert_equal expected, statey.writing
  # end
end

#

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
