require 'pry'
require './lib/statewidetest'
# require './lib/statewidetest_parser'


class StatewideTestRepository
  attr_reader :statewide_tests, :key

  def initialize
    @statewide_tests = []
  end

  def load_data(hash)
    parser = StatewideTestParser.new
    load_files = peel_hash_to_key_file(hash)
    load_files.each do |key, file|
      @key = key
      district_statewidetest_data_over_time = parser.parse(key, file)
      create_enrollments(district_statewidetest_data_over_time)
    end
  end

  def peel_hash_to_key_file(hash)
    hash.values[0].to_a
  end

  # def create_statewide_test(hash_line)
  #   if find_by_name(hash_line[:name])
  #     find_by_name(hash_line[:name]).send()
  #   else
  #     @statewide_tests << StatewideTest.new(hash_line)
  #   end
  # end

  def find_by_name(test_name)
     @statewide_tests.find {|statewidetest| statewidetest.name == district.upcase }
    # returns either nil or an instance of StatewideTest having done a case insensitive search
  end
end


# name = "ACADEMY 20"
# data = {:third_grade => {big data hash}, :eighth_grade => {big data hash}}









#
# def create_enrollments(district_enrollment_array)
#   district_enrollment_array.each do |hash_line|
#     create_enrollment(hash_line)
#   end
# end
#
# def create_enrollment(hash_line)
#   if find_by_name(hash_line[:name])
#     find_by_name(hash_line[:name]).high_school_graduation = hash_line[:high_school_graduation]
#   else
#     @enrollments << Enrollment.new(hash_line)
#   end
# end
#
# def add_records(records)
#   @enrollments += records
# end
#
# # Case insensitive. Input is string. Output is Enrollment object
# def find_by_name(district)
#   @enrollments.find {|enrollment| enrollment.name == district.upcase }
# end
#
# end
