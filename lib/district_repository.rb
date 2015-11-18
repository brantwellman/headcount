require_relative "district"
require_relative 'enrollment_repository'
require_relative 'statewidetest_repository'

class DistrictRepository
  attr_accessor :districts, :enrollment_repository, :statewidetest_repository

  def initialize
    @districts = []
    @enrollment_repository = EnrollmentRepository.new
    @statewidetest_repository = StatewideTestRepository.new
  end

  def load_data(hash)
    @enrollment_repository.load_data(:enrollment => hash[:enrollment])
    @statewidetest_repository.load_data(:statewide_testing => hash[:statewide_testing])
    load_repos({
      :enrollment => @enrollment_repository,
      :statewide_testing => @statewidetest_repository
    })
  end

  def load_repos(repos)
    repos.each do |key, repo|
      add_to_districts_from_repositories(key, repo)
    end
  end

  def add_to_districts_from_repositories(key, repository)
    district_names = repository.send(key.to_s + "s").map(&:name).uniq
    district_names.map do |name|
      district = find_by_name(name)
      if district.nil?
        district = District.new({name: name})
        district.send("set_" + key.to_s, repository.find_by_name(district.name))
            @districts << district
      else
        district.send("set_" + key.to_s, repository.find_by_name(district.name))
      end
    end
  end

  def find_by_name(district_name)
    @districts.find {|district| district.name == district_name.upcase }
  end

  def find_all_matching(str_fragment)
    @districts.select { |district| district.name.include?(str_fragment.upcase)}
  end
end

# dr = DistrictRepository.new
# dr.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv",
#     :high_school_graduation => "./data/High school graduation rates.csv",
#   },
#   :statewide_testing => {
#     :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
#     :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
#     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
#     :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
#     :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
#   }
# })
# p district = dr.find_by_name("ACADEMY 20")
# statewide_test = district.statewide_test
# p dr.districts.count

# dr = DistrictRepository.new
# dr.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv",
#     :high_school_graduation => "./data/High school graduation rates.csv"
#   }
# })
# district = dr.find_by_name("ACADEMY 20")
# district = dr.find_by_name("GUNNISON WATERSHED RE1J")
# p dr.districts[50].enrollment.name
# district.enrollment.kindergarten_participation_by_year
# p district.enrollment.kindergarten_participation_in_year(2010)
# p dr.districts.count
 # p district.enrollment.kindergarten_participation_in_year(2004)
