require 'pry'
require_relative 'statewidetest'
require_relative 'statewidetest_parser'

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
      create_statewide_tests(district_statewidetest_data_over_time)
    end
  end

  def peel_hash_to_key_file(hash)
    hash.values[0].to_a
  end

  def create_statewide_tests(district_statewide_test_array)
    district_statewide_test_array.each do |hash_line|
      create_statewide_test(hash_line)
    end
  end

  def create_statewide_test(hash_line)
    method_name = ("set_" + @key.to_s).to_sym
    if find_by_name(hash_line[:name])
      find_by_name(hash_line[:name]).send(method_name, hash_line[@key])
    else
      @statewide_tests << StatewideTest.new(hash_line)
    end
  end

  def add_records(records)
    @statewide_tests += records
  end

  def find_by_name(test_name)
     @statewide_tests.find {|statewidetest| statewidetest.name == test_name.upcase }
  end
end

# str = StatewideTestRepository.new
# hash = ({
#   :statewide_testing => {
#     :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
#     :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
#     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
#     :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
#     :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
#   }
# })
# str.load_data(hash)
# # p str.find_by_name("ACADEMY 20")
# p str.statewide_tests
