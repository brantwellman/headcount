require_relative 'unknown_data_error'
require 'pry'

class EconomicProfile
  attr_reader :name
  attr_accessor :median_household_income, :children_in_poverty, :free_or_reduced_price_lunch, :title_i

  def initialize(data_hash)
    @name = data_hash[:name]
    @median_household_income = data_hash[:median_household_income]
    @children_in_poverty = data_hash[:children_in_poverty]
    @free_or_reduced_price_lunch = data_hash[:free_or_reduced_price_lunch]
    @title_i = data_hash[:title_i]
  end

  def estimated_median_household_income_in_year(year)
    my_averagin_array = []
    median_household_income.keys.each do |year_range|
      if year_range.is_a?(Integer) && year_range == year
        my_averagin_array << median_household_income[year_range]
      else
        if year.between?(year_range[0], year_range[1])
          my_averagin_array << median_household_income[year_range]
        end
      end
    end
    foo = my_averagin_array.reduce(:+)
    raise UnknownDataError.new("Not a valid year") unless foo
    foo / my_averagin_array.count
  end

  def median_household_income_average
    values = median_household_income.values
    values.reduce(:+) / values.count
  end

  def children_in_poverty_in_year(year)
    if children_in_poverty.keys.include?(year)
      truncate(children_in_poverty[year])
    else
      raise UnknownDataError.new("Not a valid year")
    end
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    if free_or_reduced_price_lunch.keys.include?(year)
      truncate(free_or_reduced_price_lunch[year][:percentage])
    else
      raise UnknownDataError.new("Not a valid year")
    end
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    if free_or_reduced_price_lunch.keys.include?(year)
      truncate(free_or_reduced_price_lunch[year][:total])
    else
      raise UnknownDataError.new("Not a valid year")
    end
  end

  def title_i_in_year(year)
    if title_i[year]
      title_i[year]
    else
      raise UnknownDataError.new("Not a valid year")
    end
  end

  def set_median_household_income(value)
    @median_household_income = value
  end

  def set_children_in_poverty(value)
    @children_in_poverty = value
  end

  def set_free_or_reduced_price_lunch(value)
    @free_or_reduced_price_lunch = value
  end

  def set_title_i(value)
    @title_i = value
  end

  def truncate(float)
    (float * 1000).floor / 1000.to_f
  end
end
