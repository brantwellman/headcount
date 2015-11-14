require 'csv'
require 'pry'
class EnrollmentParser
  attr_reader :formatted_rows, :enrollment_objects

  def initialize
    @formatted_rows = []
    @enrollment_objects = []
  end

  def parse(key, file)
    @formatted_rows = []
    handle = CSV.open(file, {:headers => true, header_converters: :symbol })
    handle.each do |row|
      fancy_row = {:name => row[:location].upcase, key => {row[:timeframe].to_i => row[:data].to_f.round(3)}}
      @formatted_rows << fancy_row
    end
    format_nested_hashes(key)
  end

  def group_to_nested_hash(group, key)

    nested_hash = nil
    group.each do |hash|
      nested_hash ||= hash
      nested_hash[key] = nested_hash[key].merge(hash[key])
    end
     nested_hash
  end

  def format_nested_hashes(key)
    @formatted_rows.group_by { |r| r[:name] }.values.map do |group|
      group_to_nested_hash(group, key)
    end
  end

end

x = EnrollmentParser.new
puts x.parse(:kindergarten, "./test/fixtures/two_districts.csv")
