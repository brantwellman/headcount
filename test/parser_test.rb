require 'minitest'
require 'minitest/autorun'
require '../lib/parser'
#require './fixtures/little_csv'

class ParserTest < Minitest::Test

  def test_exists
    assert Parser.new
  end

  def test_object_is_an_instance_of_class
    parsy = Parser.new
    assert parsy.is_a?(Parser)
  end

  def test_it_parses_csv_file
    parsy = Parser.new
    result = parsy.parse('./fixtures/little_csv.csv')
    expected = [{:name=>"colorado", 2006=>0.33677}, {:name=>"colorado", 2005=>0.27807}, {:name=>"colorado", 2004=>0.24014}, {:name=>"colorado", 2008=>0.5357}, {:name=>"colorado", 2009=>0.598}, {:name=>"colorado", 2010=>0.64019}, {:name=>"colorado", 2011=>0.672}, {:name=>"colorado", 2012=>0.695}, {:name=>"colorado", 2013=>0.70263}, {:name=>"colorado", 2014=>0.74118}]
    assert_equal expected, result
  end

  def test_it_converts_array_to_data_hash
    parsey = Parser.new
    array = ["AGATE 300","2006","Percent","#DIV/0!"]
    expected = {:name => "agate 300", 2006 => 0.0}
    assert_equal expected, parsey.convert_array_to_data_hash(array)
  end

  def test_it_splits_a_line_to_an_array
    parsey = Parser.new
    line = "ADAMS-ARAPAHOE 28J,2007,Percent,0.47359\n"
    expected = ["ADAMS-ARAPAHOE 28J", "2007", "Percent", "0.47359"]
    assert_equal expected, parsey.split_line_to_data_array(line)
  end

end
