require 'minitest'
require 'minitest/autorun'
require './lib/enrollment_parser'

class EnrollmentParserTest < Minitest::Test

  def test_it_exists
    assert EnrollmentParser
  end

  def test_an_object_is_an_instance_of_class
    ep = EnrollmentParser.new
    assert ep.is_a?(EnrollmentParser)
  end

  def test_group_to_nested_hash_takes_an_array_of_a_single_hash
    group = [{:name=>"COLROADO", :kindergarten => {2011 =>0.672}}]
    ep = EnrollmentParser.new
    expected = {:name=>"COLROADO", :kindergarten => {2011 =>0.672}}
    result = ep.group_to_nested_hash(group, :kindergarten)
    assert_equal result, expected
  end

  def test_group_to_nested_hash_takes_an_array_of_hashes_and_merges_them
    group = [{:name=>"COLROADO", :kindergarten => {2011 =>0.672}},{:name=>"COLROADO", :kindergarten => {2012 =>0.695}}]
    ep = EnrollmentParser.new
    expected = {:name=>"COLROADO", :kindergarten => {2011 =>0.672, 2012 => 0.695}}
    result = ep.group_to_nested_hash(group, :kindergarten)
    assert_equal result, expected
  end

  def def_group_to_nested_hash_takes_a_larger_array_of_hashes test_group_to_nested_hash_takes_an_array_of_hashes_and_merges_them
    group = [{:name=>"COLROADO", :kindergarten => {2011 =>0.672}},{:name=>"COLROADO", :kindergarten => {2012 =>0.601}},{:name=>"COLROADO", :kindergarten => {2013 =>0.602}},{:name=>"COLROADO", :kindergarten => {2014 =>0.603}},{:name=>"COLROADO", :kindergarten => {2015 =>0.695}}]
    ep = EnrollmentParser.new
    expected = {:name=>"COLROADO", :kindergarten => {2011 =>0.672, 2012 => 0.695, 2013 =>0.602, 2014 => 0.603, 2015 => 0.695}}
    result = ep.group_to_nested_hash(group, :kindergarten)
    assert_equal result, expected
  end

  def test_format_nested_hashes_returns_for_one_group
    formatted_rows = [{:name=>"COLORADO", :kindergarten=>{2011=>0.672}},
    {:name=>"COLORADO", :kindergarten=>{2012=>0.695}},
    {:name=>"COLORADO", :kindergarten=>{2013=>0.703}},
    {:name=>"COLORADO", :kindergarten=>{2014=>0.741}}]
    ep = EnrollmentParser.new
    expected = [{:name=>"COLORADO", :kindergarten=>{2011=>0.672, 2012=>0.695, 2013=>0.703, 2014=>0.741}}]
    result = ep.format_nested_hashes(:kindergarten, formatted_rows)
    assert_equal result, expected
  end

  def test_format_nested_hashes_returns_an_array_of_hashes_wherein_name_keys_match
      formatted_rows = [{:name=>"COLORADO", :kindergarten=>{2011=>0.672}},
   {:name=>"COLORADO", :kindergarten=>{2012=>0.695}},
   {:name=>"COLORADO", :kindergarten=>{2013=>0.703}},
   {:name=>"COLORADO", :kindergarten=>{2014=>0.741}},
   {:name=>"ACADEMY 20", :kindergarten=>{2007=>0.392}},
   {:name=>"ACADEMY 20", :kindergarten=>{2006=>0.354}},
   {:name=>"ACADEMY 20", :kindergarten=>{2005=>0.267}},
   {:name=>"ACADEMY 20", :kindergarten=>{2004=>0.302}},
   {:name=>"ACADEMY 20", :kindergarten=>{2008=>0.385}}]
       ep = EnrollmentParser.new
       ep.format_nested_hashes(:kindergarten, formatted_rows)
       expected = [{:name=>"COLORADO", :kindergarten=>{2011=>0.672, 2012=>0.695, 2013=>0.703, 2014=>0.741}},
   {:name=>"ACADEMY 20", :kindergarten=>{2007=>0.392, 2006=>0.354, 2005=>0.267, 2004=>0.302, 2008=>0.385}}]
   result = ep.format_nested_hashes(:kindergarten, formatted_rows)
   assert_equal result, expected
  end

  def test_parse_takes_a_csv_file_and_returns_parsed_hashes
    ep = EnrollmentParser.new
    expected = [{:name=>"COLORADO", :kindergarten=>{2011=>0.672, 2012=>0.695, 2013=>0.703, 2014=>0.741}},
    {:name=>"ACADEMY 20", :kindergarten=>{2007=>0.392, 2006=>0.354, 2005=>0.267, 2004=>0.302, 2008=>0.385}}]
    result = ep.parse(:kindergarten, "./test/fixtures/two_districts.csv")
    assert_equal result, expected
    end


end
