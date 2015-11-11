require 'minitest'
require 'minitest/autorun'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_it_initializes_with_a_name
    enroll = Enrollment.new({:name => "Colorado", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal "COLORADO", enroll.name
  end

  def test_it_initializes_with_a_kindergarten_participation_hash
    enroll = Enrollment.new({:name => "Colorado", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    expected = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}

    assert_equal expected, enroll.kindergarten_participation
  end

  def test_it_returns_the_enrollment_participation_by_year_with_rounded_floats
    enroll = Enrollment.new({:name => "Colorado", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    expected = {2010 => 0.392, 2011 => 0.354, 2012 => 0.268}

    assert_equal expected, enroll.kindergarten_participation_by_year
  end

  def test_it_returns_the_enrollment_for_a_specfic_year_as_rounded_float
    enroll = Enrollment.new({:name => "Colorado", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    expected = 0.392

    assert_equal expected, enroll.kindergarten_participation_in_year(2010)
  end

  def test_it_returns_the_enrollment_for_a_specfic_year_as_rounded_float_from_2_digit_float
    enroll = Enrollment.new({:name => "Colorado", :kindergarten_participation => {2010 => 0.39, 2011 => 0.35356, 2012 => 0.2677}})
    expected = 0.39

    assert_equal expected, enroll.kindergarten_participation_in_year(2010)
  end

  def test_it_returns_nil_for_an_unknown_year
    enroll = Enrollment.new({:name => "Colorado", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    expected = nil

    assert_equal expected, enroll.kindergarten_participation_in_year(2015)
  end
end
