require "./lib/district"
require './lib/enrollment_repository'

class DistrictRepository
  attr_accessor :districts, :enrollment_repository

  def initialize
    @districts = []
    @enrollment_repository = EnrollmentRepository.new
  end

  def load_data(hash)
    @enrollment_repository.load_data(hash)
    load_repos({:enrollment => @enrollment_repository})
  end

  def load_parsed_data(district_enrollment_array)
    @enrollment_repository.create_enrollments(district_enrollment_array)
    load_repos({:enrollment => @enrollment_repository})
  end

  def load_repos(repos)
    @enrollment_repository = repos[:enrollment]
    create_districts_from_repositories
  end

  def create_districts_from_repositories
    district_names = enrollment_repository.enrollments.map do |enrollment|
      enrollment.name
    end.uniq
    districts = district_names.map do |name|
      district = District.new({name: name})
      district.enrollment = enrollment_repository.find_by_name(district.name)
      district
    end
    @districts = districts
  end

  # Case insensitive. input is string. Output is District object
  def find_by_name(district_name)
    @districts.find {|district| district.name == district_name.upcase }
  end

  # Case insensitive. Input - String fragment. Output either [] or array with matches
  def find_all_matching(str_fragment)
    @districts.select { |district| district.name.include?(str_fragment.upcase)}
  end
end

dr = DistrictRepository.new
dr.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv",
  },
  :statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  }
})
p district = dr.find_by_name("ACADEMY 20")
p district.statewide_test

# p enrollment = dr.find_by_name("ACADEMY 20")
# p dr.districts[50].enrollment.name
 # district = dr.find_by_name("Academy 20")
# p district.enrollment.kindergarten_participation_by_year
# p district.enrollment.kindergarten_participation_in_year(2010)
p dr.districts.count
#<District:0x007fe32491f5a0 @name="YUMA SCHOOL DISTRICT 1", @enrollment=#<Enrollment:0x007fe324944b98 @name="YUMA SCHOOL DISTRICT 1", @kindergarten_participation={"2007"=>"1", "2006"=>"1", "2005"=>"1", "2004"=>"0", "2008"=>"1", "2009"=>"1", "2010"=>"1", "2011"=>"1", "2012"=>"1", "2013"=>"1", "2014"=>"1"}>>]
