require 'minitest'
require 'minitest/autorun'
require_relative '../lib/district'
require_relative '../lib/district_repository'


class DistrictTest < Minitest::Test

  def test_that_it_initializes_with_a_name
    district = District.new({:name => "COLORADO"})
    expected = "COLORADO"

    assert_equal expected, district.name
  end

  def test_it_has_access_to_enrollment_in_collection_of_1_kindergarten
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
        :name => "ACADEMY 20",
        :kindergarten => {
          2010 => 0.3915,
          2011 => 0.35356,
          2012 => 0.2677
        }
    })
    e_repo.add_records([e1])
    d_repo.load_repos({:enrollment => e_repo})

    assert_equal "ACADEMY 20", d_repo.districts[0].enrollment.name
  end


  def test_it_has_access_to_enrollment_in_collection_of_1_high_school_graduation
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ACADEMY 20",
      :high_school_graduation => {
        2010 => 0.3915,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    e_repo.add_records([e1])
    d_repo.load_repos({:enrollment => e_repo})

    assert_equal "ACADEMY 20", d_repo.districts[0].enrollment.name
  end

  def test_it_has_access_to_enrollment_in_collection_of_2
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    h1 = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten => {
        2010 => 0.3915,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    h2 = Enrollment.new({
      :name => "COLORADO",
      :kindergarten => {
        2010 => 0.3915,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    e_repo.add_records([h1, h2])
    d_repo.load_repos({:enrollment => e_repo})

    assert_equal "ACADEMY 20", d_repo.districts[0].enrollment.name
    assert_equal "COLORADO", d_repo.districts[1].enrollment.name
  end

  def test_it_has_access_to_enrollment_methods_participation_in_year
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => {
        2010 => 0.392,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    e2 = Enrollment.new({
      :name => "COLORADO",
      :kindergarten_participation => {
        2010 => 0.392,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    e_repo.add_records([e1, e2])
    d_repo.load_repos({:enrollment => e_repo})

    assert_equal 0.392, d_repo.districts[0].enrollment.kindergarten_participation_in_year(2010)
  end

  def test_it_has_access_to_enrollment_methods_graduation_rate_by_year
    d_repo = DistrictRepository.new
    e_repo = EnrollmentRepository.new
    e1 = Enrollment.new({
      :name => "ACADEMY 20",
      :high_school_graduation => {
        2010 => 0.392,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    e2 = Enrollment.new({
      :name => "COLORADO",
      :high_school_graduation => {
        2010 => 0.392,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    e_repo.add_records([e1, e2])
    d_repo.load_repos({:enrollment => e_repo})
    expected = {2010=>0.392, 2011=>0.353, 2012=>0.267}

    assert_equal expected, d_repo.districts[0].enrollment.graduation_rate_by_year
  end
end
