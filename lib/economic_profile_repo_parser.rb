require 'csv'
require 'pry'

class EconomicProfileRepoParser
  attr_reader :formatted_hashes

def initialize
  @formatted_hashes = []
end

def method1(some_hash={})
  CSV.foreach("data/Median household income.csv", headers: true) do |row|
    school_title = row[0].gsub(" ", "_").to_sym
    date_key = row[1].split('-').map {|element| element.to_i}

    unless some_hash[school_title]
      some_hash[school_title] = {}
    end

    unless some_hash[school_title][:median_household_income]
      some_hash[school_title][:median_household_income] = {}
    end

    some_hash[school_title][:median_household_income][date_key] = row[3].to_i
    some_hash[school_title][:name] ||= row[0]

    #binding.pry
  end
  some_hash
end

def method2(some_hash={})
  CSV.foreach("data/School-aged children in poverty.csv", headers: true) do |row|
    school_title = row[0].gsub(" ", "_").to_sym
    date_key = row[1].to_i

    unless some_hash[school_title]
      some_hash[school_title] = {}
    end

    unless some_hash[school_title][:children_in_poverty]
      some_hash[school_title][:children_in_poverty] = {}
    end
    if row[2] == "Percent"
      some_hash[school_title][:children_in_poverty][date_key] = row[3].to_f
    end

    some_hash[school_title][:name] ||= row[0]

    #binding.pry
  end
  some_hash
end

def method3(some_hash={})
  CSV.foreach("data/Students qualifying for free or reduced price lunch.csv", headers: true) do |row|
    school_title = row[0].gsub(" ", "_").to_sym
    date_key = row[2].to_i
    unless some_hash[school_title]
      some_hash[school_title] = {}
    end

    unless some_hash[school_title][:free_or_reduced_price_lunch]
      some_hash[school_title][:free_or_reduced_price_lunch] = {}
    end

    unless some_hash[school_title][:free_or_reduced_price_lunch][date_key]
      some_hash[school_title][:free_or_reduced_price_lunch][date_key] = {}
    end

    if row[1] == "Eligible for Free or Reduced Lunch"
      if row[3] == "Number"
        some_hash[school_title][:free_or_reduced_price_lunch][date_key][row[3].to_sym] = row[4].to_i
      elsif row[3] == "Percent"
        some_hash[school_title][:free_or_reduced_price_lunch][date_key][row[3].to_sym] = row[4].to_f
      end
    end

    some_hash[school_title][:name] ||= row[0]

    #binding.pry
  end
  some_hash
end

def method4(some_hash={})
  CSV.foreach("data/Title I students.csv", headers: true) do |row|
    school_title = row[0].gsub(" ", "_").to_sym
    date_key = row[1].to_i

    unless some_hash[school_title]
      some_hash[school_title] = {}
    end

    unless some_hash[school_title][:title_i]
      some_hash[school_title][:title_i] = {}
    end

    some_hash[school_title][:title_i][date_key] = row[3].to_f
    some_hash[school_title][:name] ||= row[0]

  end
  @formatted_hashes << some_hash
end

  def parse
    method4(method3(method2(method1)))[0].map {|hash| hash.to_a}
  end
end

#
# eprp = EconomicProfileRepoParser.new
# # eprp.method4(eprp.method3(eprp.method2(eprp.method1)))
# # puts eprp.formatted_hashes[0].values[0]
# # p eprp.method3(method2(method1))
# puts eprp.parse.inspect
#

# csv 1
# some_hash = some_method1
#
# #csv 3
# some_hash = some_method3(some_hash)
