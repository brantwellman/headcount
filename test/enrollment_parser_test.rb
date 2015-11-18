require 'minitest'
require 'minitest/autorun'
require_relative '../lib/enrollment_parser'

class EnrollmentParserTest < Minitest::Test

  def test_it_exists
    assert EnrollmentParser
  end

  def test_an_object_is_an_instance_of_class
    ep = EnrollmentParser.new
    assert ep.is_a?(EnrollmentParser)
  end

  def test_group_to_nested_hash_takes_an_array_of_a_single_hash
    group = [{:name=>"COLROADO", :kindergarten_participation => {2011 =>0.672}}]
    ep = EnrollmentParser.new
    expected = {:name=>"COLROADO", :kindergarten_participation => {2011 =>0.672}}
    result = ep.group_to_nested_hash(group, :kindergarten_participation)
    assert_equal result, expected
  end

  def test_group_to_nested_hash_takes_an_array_of_hashes_and_merges_them
    group = [{:name=>"COLROADO", :kindergarten_participation => {2011 =>0.672}},{:name=>"COLROADO", :kindergarten_participation => {2012 =>0.695}}]
    ep = EnrollmentParser.new
    expected = {:name=>"COLROADO", :kindergarten_participation => {2011 =>0.672, 2012 => 0.695}}
    result = ep.group_to_nested_hash(group, :kindergarten_participation)
    assert_equal result, expected
  end

  def def_group_to_nested_hash_takes_a_larger_array_of_hashes test_group_to_nested_hash_takes_an_array_of_hashes_and_merges_them
    group = [{:name=>"COLROADO", :kindergarten_participation => {2011 =>0.672}},{:name=>"COLROADO", :kindergarten_participation => {2012 =>0.601}},{:name=>"COLROADO", :kindergarten_participation => {2013 =>0.602}},{:name=>"COLROADO", :kindergarten_participation => {2014 =>0.603}},{:name=>"COLROADO", :kindergarten_participation => {2015 =>0.695}}]
    ep = EnrollmentParser.new
    expected = {:name=>"COLROADO", :kindergarten_participation => {2011 =>0.672, 2012 => 0.695, 2013 =>0.602, 2014 => 0.603, 2015 => 0.695}}
    result = ep.group_to_nested_hash(group, :kindergarten_participation)
    assert_equal result, expected
  end

  def test_format_nested_hashes_returns_for_one_group
    formatted_rows = [{:name=>"COLORADO", :kindergarten_participation=>{2011=>0.672}},
    {:name=>"COLORADO", :kindergarten_participation=>{2012=>0.695}},
    {:name=>"COLORADO", :kindergarten_participation=>{2013=>0.703}},
    {:name=>"COLORADO", :kindergarten_participation=>{2014=>0.741}}]
    ep = EnrollmentParser.new
    expected = [{:name=>"COLORADO", :kindergarten_participation=>{2011=>0.672, 2012=>0.695, 2013=>0.703, 2014=>0.741}}]
    result = ep.format_nested_hashes(:kindergarten_participation, formatted_rows)
    assert_equal result, expected
  end

  def test_format_nested_hashes_returns_an_array_of_hashes_wherein_name_keys_match
      formatted_rows = [{:name=>"COLORADO", :kindergarten_participation=>{2011=>0.672}},
   {:name=>"COLORADO", :kindergarten_participation=>{2012=>0.695}},
   {:name=>"COLORADO", :kindergarten_participation=>{2013=>0.703}},
   {:name=>"COLORADO", :kindergarten_participation=>{2014=>0.741}},
   {:name=>"ACADEMY 20", :kindergarten_participation=>{2007=>0.392}},
   {:name=>"ACADEMY 20", :kindergarten_participation=>{2006=>0.354}},
   {:name=>"ACADEMY 20", :kindergarten_participation=>{2005=>0.267}},
   {:name=>"ACADEMY 20", :kindergarten_participation=>{2004=>0.302}},
   {:name=>"ACADEMY 20", :kindergarten_participation=>{2008=>0.385}}]
       ep = EnrollmentParser.new
       ep.format_nested_hashes(:kindergarten_participation, formatted_rows)
       expected = [{:name=>"COLORADO", :kindergarten_participation=>{2011=>0.672, 2012=>0.695, 2013=>0.703, 2014=>0.741}},
   {:name=>"ACADEMY 20", :kindergarten_participation=>{2007=>0.392, 2006=>0.354, 2005=>0.267, 2004=>0.302, 2008=>0.385}}]
   result = ep.format_nested_hashes(:kindergarten_participation, formatted_rows)
   assert_equal result, expected
  end

  def test_convert_na_handles_strings_of_1_and_0_to_floats
    ep = EnrollmentParser.new
    expected = [{:name=>"ACADEMY 20", :high_school_graduation=>{2013=>1.0, 2014=>1.0}}, {:name=>"AGATE 300", :high_school_graduation=>{2010=>0.0, 2011=>1.0}}]
    result = ep.parse(:high_school_graduation, "./test/fixtures/hs_data_1s_and_0s.csv")
    assert_equal expected, result
  end

  def test_parse_takes_a_csv_file_and_returns_parsed_hashes
    ep = EnrollmentParser.new
    expected = [{:name=>"COLORADO", :kindergarten_participation=>{2011=>0.672, 2012=>0.695, 2013=>0.70263, 2014=>0.74118}}, {:name=>"ACADEMY 20", :kindergarten_participation=>{2007=>0.39159, 2006=>0.35364, 2005=>0.26709, 2004=>0.30201, 2008=>0.38456}}]
    result = ep.parse(:kindergarten, "./test/fixtures/two_districts.csv")
    assert_equal expected, result
  end

  def test_parse_works_with_larger_CSV_and_more_many_more_lines
    ep = EnrollmentParser.new
    expected = 181
    result = ep.parse(:kindergarten, "./data/Kindergartners in full-day program.csv").length
    assert_equal result, expected
  end
end
