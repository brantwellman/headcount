require 'pry'
require './lib/enrollment'
require './lib/enrollment_parser'

class EnrollmentRepository
  attr_reader :enrollments
  attr_accessor :key

  def initialize
    @enrollments = []
  end

  # Input is nested hash. No Output. Generates Enrollment Objects
  def load_data(hash)
    parser = EnrollmentParser.new
    load_files = peel_hash_to_key_file(hash)
    load_files.each do |key, file|
      @key = key
      # binding.pry
      district_enrollment_data_over_time = parser.parse(key, file)
      create_enrollments(district_enrollment_data_over_time)
    end
  end

  def peel_hash_to_key_file(hash)
    hash.values[0].to_a
  end

  def create_enrollments(district_enrollment_array)
    district_enrollment_array.each do |hash_line|
      create_enrollment(hash_line)
    end
  end

  def create_enrollment(hash_line)
    method_name = ("set_" + @key.to_s).to_sym
    if find_by_name(hash_line[:name])
      find_by_name(hash_line[:name]).send(method_name, hash_line[@key])
    else
      @enrollments << Enrollment.new(hash_line)
    end
  end

  def add_records(records)
    @enrollments += records
  end

 # Case insensitive. Input is string. Output is Enrollment object
  def find_by_name(district)
    @enrollments.find {|enrollment| enrollment.name == district.upcase }
  end
end

# er = EnrollmentRepository.new
# er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv",
#     :high_school_graduation => "./data/High school graduation rates.csv"
#   }
# })
# #  enrollment = er.find_by_name("Colorado")
# # p enrollment.graduation_rate_by_year
# # # # puts enrollment.kindergarten_participation_by_year
# # # # # puts enrollment.kindergarten_participation_in_year(2010)
# # # # # puts dr.find_by_name("ACADEMY 20")
# # # # # p dr.districts
# p er.enrollments
# p er.enrollments.count
