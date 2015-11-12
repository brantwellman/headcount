require 'csv'
require 'pry'
class EnrollmentParser
  attr_reader :formatted_rows, :enrollment_objects

  def initialize
    @formatted_rows = []
    @enrollment_objects = []
  end

  def parse(file)
    handle = CSV.open(file, {:headers => true, header_converters: :symbol })
    handle.each do |row|
      fancy_row = {:name => row[:location], :kindergarten_participation => {row[:timeframe] => row[:data]}}
      @formatted_rows << fancy_row
    end
    format_nested_hashes
  end

  def group_to_nested_hash(group)
    nested_hash = nil
    group.each do |hash|
      nested_hash ||= hash
      nested_hash[:kindergarten_participation] = nested_hash[:kindergarten_participation].merge(hash[:kindergarten_participation])
    end
     nested_hash
  end

  def format_nested_hashes
    @formatted_rows.group_by { |r| r[:name] }.values.map do |group|
      group_to_nested_hash(group)
    end
  end

end
