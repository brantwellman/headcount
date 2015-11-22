require_relative "../lib/economic_profile_repo_parser"
require 'minitest'
require 'minitest/autorun'
require 'pry'

class EconomicProfileRepoParserTest < Minitest::Test

  def setup
    @my_hash = {
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
        }
      }

    @pre_parsed_hash = {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }

    @data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
      :children_in_poverty => {2012 => 0.1845},
      :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
      :title_i => {2015 => 0.543},
      :name => "ACADEMY 20"
      }

    @fixtures = {:economic_profile =>{
      :median_household_income =>'./test/fixtures/median_fix.csv',
      :children_in_poverty => './test/fixtures/child_pov_fix.csv',
      :free_or_reduced_price_lunch => './test/fixtures/free_lunch_fix.csv',
      :title_i => './test/fixtures/title_i_fix.csv'
        }
      }
  end

  def test_it_exists
    assert EconomicProfileRepoParser
  end

  def test_an_object_is_an_instance_of_class
    result = EconomicProfileRepoParser.new

    assert result.is_a?(EconomicProfileRepoParser)
  end

  def test_it_returns_the_first_value_in_our_hash
    eprp = EconomicProfileRepoParser.new
    result = eprp.pre_parsed(@my_hash)

    assert_equal @pre_parsed_hash, result
  end

  def test_method1_returns_a_hash_made_of_median_income_data
    eprp = EconomicProfileRepoParser.new
    result = eprp.method1(eprp.pre_parsed(@fixtures))
    expected = {:ACADEMY_20=>{:median_household_income=>{[2005, 2009]=>85060, [2006, 2010]=>85450}, :name=>"ACADEMY 20"}}

    assert_equal expected, result
  end

  def test_method2_returns_a_hash_made_of_child_poverty_data
    eprp = EconomicProfileRepoParser.new
    result = eprp.method2(eprp.pre_parsed(@fixtures))
    expected = {:ACADEMY_20=>{:children_in_poverty=>{1995=>0.032, 1997=>0.035}, :name=>"ACADEMY 20"}}

    assert_equal expected, result
  end

  def test_method3_returns_a_hash_made_of_school_lunch_data
    eprp = EconomicProfileRepoParser.new
    result = eprp.method3(eprp.pre_parsed(@fixtures))
    expected = {:ACADEMY_20=>{:free_or_reduced_price_lunch=>{2014=>{:Number=>3132, :Percent=>0.12743}, 2012=>{:Percent=>0.12539, :Number=>3006}}, :name=>"ACADEMY 20"}}

    assert_equal expected, result
  end

  def test_method4_returns_a_hash_made_of_school_lunch_data
    eprp = EconomicProfileRepoParser.new
    result = eprp.method4(eprp.pre_parsed(@fixtures))
    expected = {:ACADEMY_20=>{:title_i=>{2009=>0.014, 2011=>0.011}, :name=>"ACADEMY 20"}}

    assert_equal expected, result
  end

  def test_parse_merges_above_methods_hashes_into_single_hash
    eprp = EconomicProfileRepoParser.new
    result = eprp.parse(@fixtures)
    expected = {:ACADEMY_20=>{
                  :median_household_income=>{[2005, 2009]=>85060, [2006, 2010]=>85450},
                  :name=>"ACADEMY 20",
                  :children_in_poverty=>{1995=>0.032, 1997=>0.035},
                  :free_or_reduced_price_lunch=>{2014=>{:Number=>3132, :Percent=>0.12743},
                                                 2012=>{:Percent=>0.12539, :Number=>3006}},
                  :title_i=>{2009=>0.014, 2011=>0.011}
                    }
                  }

    assert_equal expected, result
  end








 end
