require 'csv'
require 'pry'

class EnrollmentParser
  def parse(key, file)
    key = file_converter[key]
    formatted_rows = []
    handle = CSV.open(file, {:headers => true, header_converters: :symbol })
    handle.each do |row|
      fancy_row = {
        :name => row[:location].upcase,
        key => {row[:timeframe].to_i => convert_nil(row[:data])}
      }
      formatted_rows << fancy_row
    end
    format_nested_hashes(key, formatted_rows)
  end

  def file_converter
    {
      :kindergarten =>
      :kindergarten_participation,
      :high_school_graduation =>
      :high_school_graduation
    }
  end

  def convert_nil(value)
    if value == "0" || value == "1"
      return value.to_f
    end
    float = value.to_f
    value == float.to_s ? value.to_f : nil
  end

  def group_to_nested_hash(group, key)
    nested_hash = nil
    group.each do |hash|
      nested_hash ||= hash
      nested_hash[key] = nested_hash[key].merge(hash[key])
    end

     nested_hash
  end

  def format_nested_hashes(key, formatted)
    formatted.group_by { |r| r[:name] }.values.map do |group|
      group_to_nested_hash(group, key)
    end
  end

end
