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
    # load_files = hash.values[0].values
    load_files.each do |key, file|
      # binding.pry
      district_enrollment_data_over_time = parser.parse(key, file)
      # binding.pry


      create_enrollment(district_enrollment_data_over_time)
      # binding.pry
    end
  end

  # [[:kindergarten, "./data/Kindergartners in full-day program.csv"],
  #            [:high_school_graduation, "./data/High school graduation rates.csv"]]

  def peel_hash_to_key_file(hash)
    hash.values[0].to_a
  end

  def create_enrollment(district_enrollment_array)
    district_enrollment_array.each do |hash_line|
      # if enrollments.find_by_name(name) === hashline name
      if self.find_by_name(hash_line[:name])
        # then append to that enrollment - don't create new one
        # enrollment object - find key and set value to be equal to the instance varialbe of the enrollment object
        self.find_by_name(hash_line[:name]). =
      # else
      @enrollments << Enrollment.new(hash_line)
      # end
    end
  end

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
    # :kindergarten => "./data/Kindergartners in full-day program.csv"

  }
})
enrollment = er.find_by_name("Colorado")
# # puts enrollment.kindergarten_participation_by_year
# # puts enrollment.kindergarten_participation_in_year(2010)
# # puts dr.find_by_name("ACADEMY 20")
# # p dr.districts
p enrollment
