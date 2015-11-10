class DistrictRepository
  attr_accessor :districts

  def initialize
    @districts = []
  end

  # Input is nested hash (2 layers). No Output. Generates District Objects
  def load_data(hash)
    parser = Parser.new
    file = hash.map{ |key, value| value.map{ |key, value| value}}.flatten[0]
    district_enrollment_data = parser.parse(file)
    create_districts(district_enrollment_data)
  end

  # Input is district_enrollment_data from parser. No Output. Creates District objects from array
  def create_districts(district_enrollment_data)
    district_enrollment_data.each do |hash|
      @districts << District.new(hash)
    end
  end

  # Case insensitive. input is string. Output is District object
  def find_by_name(district_name)
    @districts.find {|district| district.name == district_name.upcase }
  end

  # Case insensitive. Input - String fragment. Output either [] or array with matches
  def find_all_matching(str_fragment)
    @districts.select { |district| district.name.include?(str_fragment.upcase)}

    # []
  end

end
