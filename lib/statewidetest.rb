require_relative 'unknown_data_error'

class StatewideTest
  attr_reader :name
  attr_accessor :data
  attr_accessor :third_grade, :eighth_grade, :math, :reading, :writing

  def initialize(data_hash)
    @name = data_hash[:name]
    @third_grade = data_hash[:third_grade]
    @eighth_grade = data_hash[:eighth_grade]
    @math = data_hash[:math]
    @reading = data_hash[:reading]
    @writing = data_hash[:writing]
  end

  def proficient_by_grade(grade)
    raise UnknownDataError.new("Not a valid grade") if ![3, 8].include?(grade)
    grade_subject_converter[grade]
  end

  def grade_subject_converter
    {
      3 => @third_grade,
      8 => @eighth_grade,
      :math => @math,
      :reading => @reading,
      :writing => @writing
    }
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    val_races = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
    raise UnknownDataError.new("Not a valid subject") if ![:math, :reading, :writing].include?(subject)
    raise UnknownDataError.new("Not a valid race") if !val_races.include?(race)
    raise UnknownDataError.new("Not a valid year") if !(2011..2014).cover?(year)
    truncate(send(subject)[year][race])
  end

  def proficient_by_race_or_ethnicity(race)
    val_races = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
    raise UnknownDataError.new("Not a valid race") if !val_races.include?(race)
    converted_hash = {}
    {:math => @math, :reading => @reading,:writing => @writing}.each do |subject_key, subject_hash|
      subject_hash.each_pair do |key, hash|
          converted_hash.merge!({key => {subject_key => truncate(hash[race])}}) { |k, x, y| x.merge(y) }
      end
    end
    converted_hash
  end

  # def proficient_for_subject_by_grade_in_year(subject, grade, year)
  #
  # end

  def set_third_grade(value)
    @third_grade = value
  end

  def set_eighth_grade(value)
    @eighth_grade = value
  end

  def set_math(value)
    @math = value
  end

  def set_reading(value)
    @reading = value
  end

  def set_writing(value)
    @writing = value
  end

  def truncate(float)
    (float * 1000).floor / 1000.to_f
  end
end


# class Enrollment
#   attr_reader :name
#   attr_accessor :high_school_graduation, :kindergarten
#
#   def initialize(hash_line)
#     @name = hash_line[:name]
#     @kindergarten = hash_line[:kindergarten]
#     @high_school_graduation = hash_line[:high_school_graduation]
#   end
#
#   # Returns a hash with years as keys and truncated 3 digit float representing percentage for all years in dataset
#   def kindergarten_participation_by_year
#     kindergarten
#   end
#
#   # Input is a year as integer. If no year found, return nil. Otherwise returns a truncated three-digit floating point number representing a percentage.
#   def kindergarten_participation_in_year(year)
#     if kindergarten.keys.include?(year)
#       kindergarten[year]
#     end
#   end
#
#   def graduation_rate_by_year
#     high_school_graduation
#   end
#
#   def graduation_rate_in_year(year)
#     if high_school_graduation.keys.include?(year)
#       high_school_graduation[year]
#     end
#   end
# end
