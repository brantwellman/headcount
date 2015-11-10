class DistrictRepository
  attr_accessor :districts

  def initialize
    @districts = []
  end

  # Input is nested hash (2 layers). No Output. Generates District Objects
  def load_data(hash)
    parser = Parser.new
    file = hash.map{ |key, value| value.map{ |key, value| value}}.flatten[0]
    some_data_structure = parser.parse(file)
    create_districts(some_data_structure)
    # iterate trhough data structure.each
        # find unique district names
        # and for each district = District.new(name)
        # districts << district
  end

  # Input is some_data_structure from parser. No Output. Creates District objects from array
  def create_districts(some_data_structure)
    # iterate through data structure
    # identify unique district names
      # create district with that name
  end

  # Case insensitive. input is string. Output is District object
  def find_by_name(district_name)
    # if true
    # districts.include?(district_name)
    # returns instance of district or nil
  end

  # Case insensitive. Input - String fragment. Output either [] or array with matches
  def find_all_matching(str_fragment)

  end

end
