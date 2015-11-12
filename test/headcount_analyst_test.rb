require 'minitest'
require 'minitest/autorun'
require './lib/headcount_analyst'
require './lib/district_repository'
require './lib/enrollment_repository'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def test_that_it_gathers_array_of_enrollment_values_from_district
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => {
        2010 => 0.392,
        2011 => 0.353,
        2012 => 0.267
      }
    })
    e2 = Enrollment.new({
      :name => "Colorado",
      :kindergarten_participation => {
        2010 => 0.392,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    e_repo.add_records([e1, e2])
    d_repo.load_repos({:enrollment => e_repo})
    # binding.pry
    # ha = HeadcountAnalyst.new
# 2007=>0.392, 2006=>0.354, 2005=>0.267, 2004=>0.302, 2008=>0.385, 2009=>0.39, 2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}
    expected=[0.392, 0.353, 0.267]
    assert_equal expected, d_repo.find_by_name("Academy 20").enrollment.kindergarten_participation.values
  end
end
