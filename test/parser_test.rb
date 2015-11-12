require 'minitest'
require 'minitest/autorun'
require './lib/enrollment_parser'

class ParserTest < Minitest::Test

  def test_exists
    assert Parser.new
  end

  # def test_object_is_an_instance_of_class
  #   parsy = Parser.new
  #   assert parsy.is_a?(Parser)
  # end
  #
  # def test_it_parses_csv_file
  #   parsy = EnrollmentParser.new
  #   result = parsy.parse('./test/fixtures/little_csv.csv')
  #   expected = [{:name=>"COLORADO", :year=>2006, :enrollment=>0.33677}, {:name=>"COLORADO", :year=>2005, :enrollment=>0.27807}, {:name=>"COLORADO", :year=>2004, :enrollment=>0.24014}, {:name=>"COLORADO", :year=>2008, :enrollment=>0.5357}, {:name=>"COLORADO", :year=>2009, :enrollment=>0.598}, {:name=>"COLORADO", :year=>2010, :enrollment=>0.64019}, {:name=>"COLORADO", :year=>2011, :enrollment=>0.672}, {:name=>"COLORADO", :year=>2012, :enrollment=>0.695}, {:name=>"COLORADO", :year=>2013, :enrollment=>0.70263}, {:name=>"COLORADO", :year=>2014, :enrollment=>0.74118}]
  #
  #   assert_equal expected, result
  # end
  #
  # def test_it_parces_csv_file_consisting_of_different_districts
  #   parsy = EnrollmentParser.new
  #   result = parsy.parse('./test/fixtures/two_districts.csv')
  #   expected = [{:name=>"COLORADO", :year=>2012, :enrollment=>0.695}, {:name=>"COLORADO", :year=>2013, :enrollment=>0.703}, {:name=>"COLORADO", :year=>2014, :enrollment=>0.741}, {:name=>"ACADEMY 20", :year=>2007, :enrollment=>0.392}, {:name=>"ACADEMY 20", :year=>2006, :enrollment=>0.354}, {:name=>"ACADEMY 20", :year=>2005, :enrollment=>0.267}, {:name=>"ACADEMY 20", :year=>2004, :enrollment=>0.302}, {:name=>"ACADEMY 20", :year=>2008, :enrollment=>0.385}]
  #   assert_equal expected, result
  # end
  #
  # def test_it_converts_array_to_data_hash
  #   parsey = EnrollmentParser.new
  #   array = ["AGATE 300","2006","Percent","#DIV/0!"]
  #   expected = {:name => "AGATE 300", :year => 2006, :enrollment => 0.0}
  #   assert_equal expected, parsey.convert_array_to_data_hash(array)
  # end
  #
  # #more of these
  #
  # def test_it_splits_a_line_to_an_array
  #   parsey = EnrollmentParser.new
  #   line = "ADAMS-ARAPAHOE 28J,2007,Percent,0.47359\n"
  #   expected = ["ADAMS-ARAPAHOE 28J", "2007", "Percent", "0.47359"]
  #   assert_equal expected, parsey.split_line_to_data_array(line)
  # end

end
