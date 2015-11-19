require 'pry'
require_relative 'enrollment'
require_relative 'enrollment_parser'

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
    # binding.pry
    load_files.each do |key, file|
      @key = key
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
