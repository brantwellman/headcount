require 'csv'
require 'pry'

class Parser

  def parse(file)
    handle = CSV.open(file, {:headers => true, header_converters: :symbol })
    district_enrollment = []
    handle.each do |line|
      array = split_line_to_data_array(line)
      district_enrollment << convert_array_to_data_hash(array)
    end
    district_enrollment
  end

  def convert_array_to_data_hash(array)
    Hash[:name => array[0].downcase, array[1].to_i => array[3].to_f]
  end

  def split_line_to_data_array(line)
    line.to_s.chomp.split(',')
  end
end

# parser = Parser.new
# parser.parse("./data/Kindergartners in full-day program.csv")


# CSV.read(path, headers: true) do |row|
#   row_data = {district: row["Locationi"],
    #   years: row["Timeframe"],
    #   income: row["Data"]
    # }
    # @records << MHI.new
# end
