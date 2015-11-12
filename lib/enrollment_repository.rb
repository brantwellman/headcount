require 'pry'
require './lib/enrollment'
require './lib/enrollment_parser'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = []
  end

  # Input is nested hash. No Output. Generates Enrollment Objects
  def load_data(hash)
    parser = EnrollmentParser.new
    file = hash[:enrollment][:kindergarten]
    district_enrollment_data_over_time = parser.parse(file)
    create_enrollment(district_enrollment_data_over_time)
  end

  def create_enrollment(district_enrollment_array)
    district_enrollment_array.each do |hash_line|
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

er = EnrollmentRepository.new
er.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv"
  }
})
# puts dr.find_by_name("ACADEMY 20")
# p dr.districts
