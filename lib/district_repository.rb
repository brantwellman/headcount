require_relative "district"
require_relative 'enrollment_repository'
require_relative 'statewidetest_repository'

class DistrictRepository
  attr_accessor :districts, :enrollment_repository

  def initialize
    @districts = []
    @enrollment_repository = EnrollmentRepository.new
    @statewidetest_repository = StatewideTestRepository.new
  end

  def load_data(hash)
    @enrollment_repository.load_data(hash)
    load_repos({:enrollment => @enrollment_repository})
  end

  # def load_data(hash)
  #   key_files = hash.to_a
  #   key_files.each_with_index do |key_file, index|
  #     if key_file[index][0] == :enrollment
  #       @enrollmnet_repository.load_data(hash)
  #       load_repos({:enrollmnet => @enrollment_repository})
  #       # enrollment_load(hash)
  #     elsif key_file[index][0] == :statewide_testing
  #       @statewidetest_repository.load_data(hash)
  #       load_repos({:statewide_testing => @statewidetest_repository})
  #       # statewidetest_load(hash)
  #     end
  #   end
  # end

# create enrollment specific load data method
# create statewidetesting specific load data method

  def enrollment_load(hash)
    @enrollmnet_repository.load_data(hash)
    load_repos({:enrollmnet => @enrollment_repository})
  end

  def statewidetest_load(hash)
    @statewidetest_repository.load_data(hash)
    load_repos({:statewide_testing => @statewidetest_repository})
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


# dr = DistrictRepository.new
# dr.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv",
#     :high_school_graduation => "./data/High school graduation rates.csv"
#   }
# })
# p enrollment = dr.find_by_name("ACADEMY 20")
# p dr.districts[50].enrollment.name
# p district = dr.find_by_name("Academy 20")
# p district.enrollment.kindergarten_participation_by_year

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
