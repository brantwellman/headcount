require 'csv'
require 'pry'

class EconomicProfileRepoParser
  attr_reader :formatted_hashes, :setup

  def initialize
    @formatted_hashes = []
  end

  def pre_parsed(input_hash)
    input_hash[:economic_profile]
  end

  def method1(pre_parsed_hash, some_hash={})
    CSV.foreach(pre_parsed_hash[:median_household_income], headers: true) do |row|
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

    end
    some_hash
  end

  def method2(pre_parsed_hash, some_hash={})
    CSV.foreach(pre_parsed_hash[:children_in_poverty], headers: true) do |row|
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

    end
    some_hash
  end

  def method3(pre_parsed_hash, some_hash={})
    CSV.foreach(pre_parsed_hash[:free_or_reduced_price_lunch], headers: true) do |row|
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

    end
    some_hash
  end

  def method4(pre_parsed_hash, some_hash={})
    CSV.foreach(pre_parsed_hash[:title_i], headers: true) do |row|
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
    @formatted_hashes << some_hash.map{|hash| hash.to_a}
    some_hash
  end

  def parse(input_hash)
    if input_hash[:economic_profile].nil?
      []
    end
    lev1 = pre_parsed(input_hash)
    lev2 = method1(lev1)
    lev3 = method2(lev1, lev2)
    lev4 = method3(lev1, lev3)
    final = method4(lev1, lev4)
  end
end
