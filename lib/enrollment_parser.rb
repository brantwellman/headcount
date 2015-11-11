require 'csv'
class EnrollmentParser

  # Location,TimeFrame,DataFormat,Data
  #
  {:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}

  def parse(file)
    handle = CSV.open(file, {:headers => true, header_converters: :symbol })
    district_enrollment = []
    handle.each do |line|
      yearly_hash = {}
      if yearly_hash.has_value?(line[:Location])
        # take existing hash and append line[:TimeFrame] => line[:Data] into value for key :kindergarten_participation
      # else :name => line[:Location] is not a key
        # then create hash => {:name => line[:Location], kindergarten_participation => {line[:TimeFrame] => line[:Data]}}

      end



      district_enrollment << Hash[:name => line[:Location], :kindergarten_participation => combine_yearly_hashes(line[:TimeFrame], line[:Data])]
    end
    district_enrollment
  end

  def combine_yearly_hashes(line[:TimeFrame], line[:Data])
    # hash[line[:Location]][line[:TimeFrame]] = line[:Data]
    hash[:kindergarten_participation]= [line[:TimeFrame], line[:Data]]
  end
      # iterate through each line
      # for empty array create hash with :name => line[:Location] plus :kindergarten_participation => {line[:TimeFrame] => line[:Data]}
      #  if line[:Location] is already a key
      #   then line[:TimeFrame] => line[:Data] gets added to :kindergarten_participation value





  #     array = split_line_to_data_array(line)
  #     district_enrollment << convert_array_to_data_hash(array)
  #   end
  #   district_enrollment
  # end

# @kg_participation[data["Location"].downcase][data["TimeFrame"]] = data["Data"]

  # def convert_array_to_data_hash(array)
  #   Hash[:name => array[0].upcase, :kindergarten_participation => {array[1].to_i => array[3].to_f}]
  # end

  # def split_line_to_data_array(line)
  #   line.to_s.chomp.split(',')
  # end
  #
  # def

  # def enrollment_hash(district_enrollment)
  #   shiny_arr = []
  #   district_enrollment.map do |enrollment_hash|
  #     if !shiny_arr.include?(enrollment_hash[:name])
  #       shiny_arr << enrollment_hash
  #     else
  #
  #

end




array = ["AGATE 300","2006","Percent","#DIV/0!"]
new_array = ["AGATE 300",{"2006"=>"#DIV/0!"}]
array2 = ["AGATE 300",{"2007"=>"0.5678"}]
