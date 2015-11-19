require 'minitest'
require 'minitest/autorun'
require_relative '../lib/statewidetest'

class StatewideTestTest < Minitest::Test

  def setup
    @data_line = {
      :name => "COLORADO",
      :third_grade => {
        2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
        2013 => {:math => 0.855, :reading => 0.859, :writing => 0.6689},
        2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
      },
      :eighth_grade => {
        2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
        2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
        2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662}
      },
      :math => {
        2011 => {
          :all => 0.68, :asian => 0.81689, :black => 0.424,
          :pacific_islander => 0.568, :hispanic => 0.568, :native_american => 0.614,
          :two_or_more => 0.677, :white => 0.9009},
        2012 => {
          :all => 0.689, :asian => 0.818, :black => 0.424,
          :pacific_islander => 0.571, :hispanic => 0.572, :native_american => 0.571,
          :two_or_more => 0.689, :white=>0.999
        }
      },
      :reading => {
        2011 => {
          :all => 0.68, :asian => 0.81689, :black => 0.424,
          :pacific_islander => 0.568, :hispanic => 0.568, :native_american => 0.614,
          :two_or_more => 0.677, :white => 0.99},
        2012 => {
          :all => 0.689, :asian => 0.818, :black => 0.424,
          :pacific_islander => 0.571, :hispanic => 0.572, :native_american => 0.571,
          :two_or_more => 0.689, :white=>0.99
        }
      },
      :writing => {
        2011 => {
          :all => 0.68, :asian => 0.81689, :black => 0.424,
          :pacific_islander => 0.568, :hispanic => 0.568, :native_american => 0.614,
          :two_or_more => 0.677, :white => 0.9999},
        2012 => {
          :all => 0.689, :asian => 0.818, :black => 0.424,
          :pacific_islander => 0.571, :hispanic => 0.572, :native_american => 0.571,
          :two_or_more => 0.689, :white=>0.99999
        }
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
      2013 => {:math => 0.855, :reading => 0.859, :writing => 0.6689},
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

  def test_it_stores_a_math_hash
    statey = StatewideTest.new(@data_line)
    expected = {
      2011 => {
        :all => 0.68, :asian => 0.81689, :black => 0.424,
        :pacific_islander => 0.568, :hispanic => 0.568, :native_american => 0.614,
        :two_or_more => 0.677, :white => 0.9009},
      2012 => {
        :all => 0.689, :asian => 0.818, :black => 0.424,
        :pacific_islander => 0.571, :hispanic => 0.572, :native_american => 0.571,
        :two_or_more => 0.689, :white=>0.999
        }

      }
    assert_equal expected, statey.math
  end

  def test_it_stores_an_reading_hash
    statey = StatewideTest.new(@data_line)
    expected = {
      2011 => {
        :all => 0.68, :asian => 0.81689, :black => 0.424,
        :pacific_islander => 0.568, :hispanic => 0.568, :native_american => 0.614,
        :two_or_more => 0.677, :white => 0.99},
      2012 => {
        :all => 0.689, :asian => 0.818, :black => 0.424,
        :pacific_islander => 0.571, :hispanic => 0.572, :native_american => 0.571,
        :two_or_more => 0.689, :white=>0.99
        }
      }
    assert_equal expected, statey.reading
  end

  def test_it_stores_an_writing_hash
    statey = StatewideTest.new(@data_line)
    expected = {
        2011 => {
          :all => 0.68, :asian => 0.81689, :black => 0.424,
          :pacific_islander => 0.568, :hispanic => 0.568, :native_american => 0.614,
          :two_or_more => 0.677, :white => 0.9999},
        2012 => {
          :all => 0.689, :asian => 0.818, :black => 0.424,
          :pacific_islander => 0.571, :hispanic => 0.572, :native_american => 0.571,
          :two_or_more => 0.689, :white=>0.99999
        }
      }
    assert_equal expected, statey.writing
  end

  def test_it_converts_integer_to_instance_variable
    statey = StatewideTest.new(@data_line)
    expected = statey.third_grade

    assert_equal expected, statey.grade_converter[3]
  end

  def test_it_converts_integer_to_instance_variable
    statey = StatewideTest.new(@data_line)
    expected = statey.eighth_grade

    assert_equal expected, statey.grade_subject_converter[8]
  end

  def test_it_returns_error_for_grade_other_than_3_or_8
    statey = StatewideTest.new(@data_line)

    assert_raises(UnknownDataError) { statey.proficient_by_grade(2) }
  end

  def test_it_returns_proficiencies_by_grade_3
    statey = StatewideTest.new(@data_line)
    expected = {
      2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
      2013 => {:math => 0.855, :reading => 0.859, :writing => 0.6689},
      2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
      }

    assert_equal expected, statey.proficient_by_grade(3)
  end

  def test_it_returns_proficiencies_by_grade_8
    statey = StatewideTest.new(@data_line)
    expected = {
      2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
      2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
      2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662}
      }

    assert_equal expected, statey.proficient_by_grade(8)
  end

  def test_it_raises_UnknownDataError_for_invalid_subject_parameter
    statey = StatewideTest.new(@data_line)

    assert_raises(UnknownDataError) { statey.proficient_for_subject_by_race_in_year(:science, :asian, 2010) }
  end

  def test_it_returns_truncated_value_given_race_year_and_subject
    statey = StatewideTest.new(@data_line)
    expected = 0.816
    assert_equal expected, statey.proficient_for_subject_by_race_in_year(:math, :asian, 2011)
  end

  def test_it_raises_UnknownDataError_for_invalid_race_parameter
    statey = StatewideTest.new(@data_line)

    assert_raises(UnknownDataError) { statey.proficient_for_subject_by_race_in_year(:math, :eskimo, 2010) }
  end

  def test_it_raises_UnknownDataError_for_invalid_year_parameter
    statey = StatewideTest.new(@data_line)

    assert_raises(UnknownDataError) { statey.proficient_for_subject_by_race_in_year(:science, :asian, 1888) }
  end

  def test_it_raises_UnknownDataError_for_invalid_parameter
    statey = StatewideTest.new(@data_line)

    assert_raises(UnknownDataError) { statey.proficient_by_race_or_ethnicity(:eskimo) }
  end

  def test_it_retuns_a_hash_grouped_by_race_for_truncated_percentages_grouped_by_suject
    statey = StatewideTest.new(@data_line)
    expected = {
              2011 => {math: 0.900, reading: 0.99, writing: 0.999},
              2012 => {math: 0.999, reading: 0.99, writing: 0.999}
              }
    assert_equal expected, statey.proficient_by_race_or_ethnicity(:white)
  end

  def test_it_raises_UnknownDataError_for_invalid_subject_parameter_subject_grade_year
    statey = StatewideTest.new(@data_line)

    assert_raises(UnknownDataError) { statey.proficient_for_subject_by_grade_in_year(:science, 3, 2010) }
  end

  def test_it_raises_UnknownDataError_for_invalid_subject_parameter_subject_grade_year
    statey = StatewideTest.new(@data_line)

    assert_raises(UnknownDataError) { statey.proficient_for_subject_by_grade_in_year(:math, 1, 2010) }
  end

  def test_it_raises_UnknownDataError_for_invalid_subject_parameter_subject_grade_year
    statey = StatewideTest.new(@data_line)

    assert_raises(UnknownDataError) { statey.proficient_for_subject_by_grade_in_year(:math, 3, 8888) }
  end


  def test_it_returns_a_truncated_value_for_subject_grade_year
    statey = StatewideTest.new(@data_line)
    expected = 0.668

    assert_equal expected, statey.proficient_for_subject_by_grade_in_year(:writing, 3, 2013)
  end

  def test_it_returns_a_value_for_subject_grade_year
    statey = StatewideTest.new(@data_line)
    expected = 0.859

    assert_equal expected, statey.proficient_for_subject_by_grade_in_year(:reading, 3, 2013)
  end

  def test_it_returns_a_value_for_subject_grade_year
    statey = StatewideTest.new(@data_line)
    expected1 = 0.855
    expected2 = 0.862

    assert_equal expected1, statey.proficient_for_subject_by_grade_in_year(:math, 3, 2013)
    assert_equal expected2, statey.proficient_for_subject_by_grade_in_year(:reading, 8, 2009)
  end

  def test_proficient_for_subject_by_race_in_year
    statey = StatewideTest.new(@data_line)
    expected1 = 0.818
    expected2 = 0.424
    expected3 = 0.571

    assert_equal expected1, statey.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
    assert_equal expected2, statey.proficient_for_subject_by_race_in_year(:math, :black, 2011)
    assert_equal expected3, statey.proficient_for_subject_by_race_in_year(:writing, :native_american, 2012)
  end

  def test_proficient_by_race_or_ethnicity
    statey = StatewideTest.new(@data_line)
    expected1 = {2011=>{:math=>0.568, :reading=>0.568, :writing=>0.568}, 2012=>{:math=>0.572, :reading=>0.572, :writing=>0.572}}
    expected2 = {2011=>{:math=>0.568, :reading=>0.568, :writing=>0.568}, 2012=>{:math=>0.571, :reading=>0.571, :writing=>0.571}}
    result1 = statey.proficient_by_race_or_ethnicity(:hispanic)
    result2 = statey.proficient_by_race_or_ethnicity(:pacific_islander)

    assert_equal expected1, result1
    assert_equal expected2, result2
  end

  def test_proficient_by_grade_returns
    statey = StatewideTest.new(@data_line)
    expected = {2012=>{:math=>0.83, :reading=>0.87, :writing=>0.655},
                2013=>{:math=>0.855, :reading=>0.859, :writing=>0.6689},
                2014=>{:math=>0.834, :reading=>0.831, :writing=>0.639}}

    assert_equal expected, statey.proficient_by_grade(3)
  end

end

#
#     def test_it_returns_expected_values_for_proficiency_by_sub_race_year
#       statey = StatewidTest.new(@data_line)
#
#       statey.proficient_for_subject_by_race_in_year(:math, 3, )
# end

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
