require 'minitest'
require 'minitest/autorun'
require './lib/statewidetest_parser'
require 'pry'

class StatewideTestParserTest < Minitest::Test

  def test_it_exists
    assert StatewideTestParser
  end

  def test_object_is_an_instance_of_class
    assert StatewideTestParser.new.is_a?(StatewideTestParser)
  end

  def test_truncate_works_with_nums_containing_less_than_three_decimal_places
    sp = StatewideTestParser.new
    assert_equal 0.1, sp.truncate(0.1)
    assert_equal 0.12, sp.truncate(0.12)
    assert_equal  12.34, sp.truncate(12.34)
  end

  def test_truncate_works_with_nums_containing_three_or_more_decimal_places
    sp = StatewideTestParser.new
    assert_equal 0.123, sp.truncate(0.123)
    assert_equal 0.123, sp.truncate(0.1234)
    assert_equal  12.345, sp.truncate(12.34567)
    assert_equal 345.999, sp.truncate(345.9999999)
  end

  def test_group_to_nested_hash_takes_an_array_with_a_couple_of_subjects
    group = [{:name=>"ACADEMY 20", :third_grade=>{2008=>{"Math"=>0.857}}},
             {:name=>"ACADEMY 20", :third_grade=>{2009=>{"Math"=>0.824}}},
             {:name=>"ACADEMY 20", :third_grade=>{2010=>{"Math"=>0.849}}},
             {:name=>"ACADEMY 20", :third_grade=>{2008=>{"Reading"=>0.866}}},
             {:name=>"ACADEMY 20", :third_grade=>{2009=>{"Reading"=>0.862}}},
             {:name=>"ACADEMY 20", :third_grade=>{2010=>{"Reading"=>0.864}}}]
    sp = StatewideTestParser.new
    expected = {:name=>"ACADEMY 20",
                  :third_grade=>{
                    2008=>{"Math"=>0.857, "Reading"=>0.866},
                    2009=>{"Math"=>0.824, "Reading"=>0.862},
                    2010=>{"Math"=>0.849, "Reading"=>0.864}}}
    result = sp.group_to_nested_hash(group, :third_grade)
    assert_equal expected, result
  end

  def test_group_to_nested_hash_takes_an_array_with_three_subjects
    group = [{:name=>"COLORADO", :third_grade=>{2008=>{"Math"=>0.957}}},
             {:name=>"COLORADO", :third_grade=>{2009=>{"Math"=>0.366}}},
             {:name=>"COLORADO", :third_grade=>{2010=>{"Math"=>0.366}}},
             {:name=>"COLORADO", :third_grade=>{2008=>{"Reading"=>0.366}}},
             {:name=>"COLORADO", :third_grade=>{2009=>{"Reading"=>0.662}}},
             {:name=>"COLORADO", :third_grade=>{2010=>{"Reading"=>0.564}}},
             {:name=>"COLORADO", :third_grade=>{2008=>{"Writing"=>0.366}}},
             {:name=>"COLORADO", :third_grade=>{2009=>{"Writing"=>0.663}}},
             {:name=>"COLORADO", :third_grade=>{2010=>{"Writing"=>0.555}}}]
    sp = StatewideTestParser.new
    expected = {:name=>"COLORADO",
                :third_grade=>{
                 2008=>{"Math"=>0.957, "Reading"=>0.366, "Writing" =>0.366},
                 2009=>{"Math"=>0.366, "Reading"=>0.662, "Writing" => 0.663},
                 2010=>{"Math"=>0.366, "Reading"=>0.564, "Writing" => 0.555}}}
    result = sp.group_to_nested_hash(group, :third_grade)
    assert_equal expected, result
  end

  def test_it_formats_nested_hashes
    formatted = [ {:name=>"ACADEMY 20", :third_grade=>{2008=>{"Math"=>0.857}}},
                  {:name=>"ACADEMY 20", :third_grade=>{2009=>{"Math"=>0.824}}},
                  {:name=>"ACADEMY 20", :third_grade=>{2010=>{"Math"=>0.849}}},
                  {:name=>"ACADEMY 20", :third_grade=>{2008=>{"Reading"=>0.866}}},
                  {:name=>"ACADEMY 20", :third_grade=>{2009=>{"Reading"=>0.862}}},
                  {:name=>"ACADEMY 20", :third_grade=>{2010=>{"Reading"=>0.864}}}]
    expected = [ {:name=>"ACADEMY 20", :third_grade=>{2008=>{"Math"=>0.857, "Reading"=>0.866},
                  2009=>{"Math"=>0.824, "Reading"=>0.862},
                  2010=>{"Math"=>0.849, "Reading"=>0.864}}}]
    sp = StatewideTestParser.new
    assert_equal expected, sp.format_nested_hashes(:third_grade, formatted)
  end

  def test_parse_takes_a_csv_file_and_returns_parsed_hashes
    sp = StatewideTestParser.new
    result = sp.parse(:third_grade, "./test/fixtures/3rd_grade_two_districts.csv")
    expected = 'x'
    assert_equal = expected, result
  end
end
