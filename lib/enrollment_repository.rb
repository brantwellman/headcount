require 'pry'
require './lib/enrollment'
require './lib/enrollment_parser'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = []
  end

  # Input is nested hash. No Output. Generates Enrollment Objects
  def load_data(hash)
    parser = EnrollmentParser.new
    load_files = peel_hash_to_key_file(hash)

    load_files.each do |key, file|
      binding.pry
            district_enrollment_data_over_time = parser.parse(key, file)
            create_enrollment(district_enrollment_data_over_time)
    end

    # parsed_files = load_files.map do |key, file|
    #   parser.parse(key, file)
    # end
    # parsed_files
    # merged_files(parsed_files)
    # district_enrollment_data_over_time = merge_files(parsed_files)
    # create_enrollment(district_enrollment_data_over_time)
      # binding.pry
  end


  # def merged_files(files)
  #     grouped = parsed_files.flatten.group_by {|hash| hash[:name]}
  #     x = Hash.new
  #     merged = grouped.each do |k, v|
  #       v.each do |hash|
  #         x.merge!(hash)
  #       end
  #       x
  #     end
  # end

  # [[:kindergarten, "./data/Kindergartners in full-day program.csv"],
  #            [:high_school_graduation, "./data/High school graduation rates.csv"]]

  def peel_hash_to_key_file(hash)
    hash.values[0].to_a
  end


# loaded_data.group_by { |hash| hash[:name] }.map { |dist_name, dist_hashes| dist_hashes.reduce(:merge)}


  def create_enrollment(district_enrollment_array)
    district_enrollment_array.each do |hash_line|
      @enrollments << Enrollment.new(hash_line)

    end
    binding.pry
  end

  # def check_for_pre_existing_enrollment
  #   # if enrollment matching name in hashline does not exist
  #   if find_by_name(hash_line[:name])
  # # add data matching your key from hashline to matching instance varialbe on pre existing
  #     find_by_name(hash_line[:name]).kindergarten = hash_line[:kindergarten]
  #     #instance variable that matches key of incoming hashline = hashline[:key that matches instance that is not name on enrollment object]
  #   else
  # end
  # if enrollment matching name in hashline does not exist
  #   then created new enrollment
  # else
      # add data matching your key from hashline to matching instance varialbe on pre existing enrollment
  # end

  # if enrollments.find_by_name(name) === hashline name
  # if find_by_name(hash_line[:name])
  #   # then append to that enrollment - don't create new one
  #   # enrollment object - find key and set value to be equal to the instance varialbe of the enrollment object
  #   find_by_name(hash_line[:name]). =
  # # else


  def add_records(records)
    @enrollments += records
  end

 # Case insensitive. Input is string. Output is Enrollment object
  def find_by_name(district)
    @enrollments.find {|enrollment| enrollment.name == district.upcase }
  end

end

er = EnrollmentRepository.new
er.load_data({
  :enrollment => {
    :high_school_graduation => "./data/High school graduation rates.csv",
    :kindergarten => "./data/Kindergartners in full-day program.csv"
  }
})
enrollment = er.find_by_name("Colorado")
# # puts enrollment.kindergarten_participation_by_year
# # puts enrollment.kindergarten_participation_in_year(2010)
# # puts dr.find_by_name("ACADEMY 20")
# # p dr.districts
p enrollment
