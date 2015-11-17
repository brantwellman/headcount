require 'csv'
require 'pry'
class StateWideDataParser
  def parse(key, file) # :statewide_testing => :third_grade
    formatted_rows = []
    handle = CSV.open(file, {:headers => true, header_converters: :symbol })
    handle.each do |row|
      binding.pry
      fancy_row = {:third_grade => {row[:timeframe].to_i => {row[:score].downcase.to_sym => row[:data].to_f.round(3)}}} #, key => {row[:timeframe].to_i => row[:data].to_f.round(3)}}
      formatted_rows << fancy_row
    end
    format_nested_hashes(key, formatted_rows)
  end

  def group_to_nested_hash(group, key)
    nested_hash = nil
    group.each do |hash|
      nested_hash ||= hash
      binding.pry
      nested_hash = nested_hash[key].merge(hash[key]) #nested_hash[key] = nested_hash[key].merge(hash[key])
    end
     nested_hash
  end

  def format_nested_hashes(key, formatted)
    formatted.group_by { |r| r[key] }.values.map do |group|
      group_to_nested_hash(group, key)
    end
  end


end

  # sw = StateWideDataParser.new
  # puts sw.parse(:timeframe, "/Users/lenny/turing/1module/projects/headcount/data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv")
