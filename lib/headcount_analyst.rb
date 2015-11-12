require './lib/district'    # ~> LoadError: cannot load such file -- ./lib/district
require './lib/enrollment'
require 'pry'

class HeadcountAnalyst
  attr_reader :de_repo

  def initialize(district_repo)
    @de_repo = district_repo
  end

  def enrollment_average(district)
    enrollment_data = de_repo.find_by_name(district.upcase).enrollment.kindergarten_participation.values
    average = enrollment_data.inject(:+)/enrollment_data.size
  end


  def kindergarten_participation_rate_variation(district, hash_comparison)
    comparison = hash_comparison.values[0].upcase
    district_average = enrollment_average(district.upcase)
    comp_average = enrollment_average(comparison)
    rate_variation = district_average/comp_average
    rate_variation.round(3)
  end

  def find_kindergarten_participation_by_year_for_district(district)
     de_repo.find_by_name(district).enrollment.kindergarten_participation
  end

  def kindergarten_participation_rate_variation_trend(district, hash_comparison)
    comparison = hash_comparison.values[0].upcase
    district_participation = find_kindergarten_participation_by_year_for_district(district)
    comparison_participation = find_kindergarten_participation_by_year_for_district(comparison)
    result = {}
    district_participation.keys.map do | year|
      #binding.pry
      result[year] = (district_participation[year] / comparison_participation[year]).round(3)
    end
    result
  end





end

  # ha.kindergarten_participation_by_year_for_district('ACADEMY 20')

# ~> LoadError
# ~> cannot load such file -- ./lib/district
# ~>
# ~> /Users/lenny/.rvm/rubies/ruby-2.2.1/lib/ruby/site_ruby/2.2.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> /Users/lenny/.rvm/rubies/ruby-2.2.1/lib/ruby/site_ruby/2.2.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> /Users/lenny/turing/1module/projects/headcount/lib/headcount_analyst.rb:1:in `<main>'
