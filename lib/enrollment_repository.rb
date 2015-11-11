require 'pry'
require './lib/enrollment'
require './lib/parser'

class EnrollmentRepository
  attr_accessor :enrollments

  def initialize
    @enrollments = []
  end

  # Input is nested hash. No Output. Generates Enrollment Objects
  def load_data(hash)
    file = hash.map{ |key, value| value.map{ |key, value| value}}.flatten[0]
    parser = EnrollmentPareser.new
    district_enrollment_data_over_time = parser.parse(file)
    create_enrollment(district_enrollment_data_over_time)
  end

  def create_enrollment(district_enrollment_array)
    district_enrollment_array.each do |hash_line|
      @enrollments << Enrollment.new(hash_line)
    end
  end

 # Case insensitive. Input is string. Output is Enrollment object
  def find_by_name(district)
    @enrollments.find {|enrollment| enrollment.name == district.upcase }
  end

end
