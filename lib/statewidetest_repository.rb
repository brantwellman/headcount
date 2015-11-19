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

  def statewide_testings
    statewide_tests
  end

#################### to be removed prior to submission
  # def add_records(records)
  #   @statewide_tests += records
  # end

  def find_by_name(test_name)
     @statewide_tests.find {|statetest| statetest.name == test_name.upcase }
  end
end
