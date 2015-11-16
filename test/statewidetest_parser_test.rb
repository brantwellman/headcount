require 'minitest'
require 'minitest/autorun'
require './lib/statewidetest_parser'
# require './lib/headcount_analyst'
# require './lib/district_repository'
# require './lib/enrollment_repository'
require 'pry'

class StatewideTestParserTest < Minitest::Test

  def test_it_exists
    assert StatewideTestParser
  end

  def test_object_is_an_instance_of_class
    assert StatewideTestParser.new.is_a?(StatewideTestParser)
  end

  # def 

end
