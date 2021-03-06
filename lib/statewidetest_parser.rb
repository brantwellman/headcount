require 'csv'
require 'pry'

class StatewideTestParser
  def parse(key, file)
    formatted_rows = []
    handle = CSV.open(file, {:headers => true, header_converters: :symbol })
    handle.each do |row|
      fancy_row = {:name => row[:location].upcase,
                   key => {
                     row[:timeframe].to_i => {
                       convert_to_symbol(row[file_converter[key]]) => convert_nil(row[:data])
                       }
                   }
                  }
      formatted_rows << fancy_row
    end
    format_nested_hashes(key, formatted_rows)
  end

  def convert_to_symbol(string)
    key_converter[string]
  end

  def key_converter
    {
      'Asian' => :asian,
      'Black' => :black,
      'Hawaiian/Pacific Islander' => :pacific_islander,
      'Hispanic' => :hispanic,
      'Native American' => :native_american,
      'Two or more' => :two_or_more,
      'White' => :white,
      'All Students' => :all,
      'Math' => :math,
      'Reading' => :reading,
      'Writing' => :writing
    }
  end

  def file_converter
    {
      :third_grade => :score,
      :eighth_grade => :score,
      :math => :race_ethnicity,
      :reading => :race_ethnicity,
      :writing => :race_ethnicity
    }
  end

  def truncate(float)
    (float * 1000).floor / 1000.to_f
  end

  def convert_nil(value)
    if value == "0" || value == "1"
      return value.to_f
    end
    float = value.to_f
    value == float.to_s ? truncate(value.to_f) : nil
  end

  def group_to_nested_hash(group, key)
    nested_hash = nil
    group.each do |hash|
      nested_hash ||= hash
      nested_hash[key] = nested_hash[key].merge(hash[key]){|k,x,y| x.merge(y) }
    end
     nested_hash
  end

  def format_nested_hashes(key, formatted)
    formatted.group_by { |r| r[:name] }.values.map do |group|
      group_to_nested_hash(group, key)
    end
  end

end
