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

  #     { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
  #      2012 => {math: 0.818, reading: 0.893, writing: 0.808},
  #      2013 => {math: 0.805, reading: 0.901, writing: 0.810},
  #      2014 => {math: 0.800, reading: 0.855, writing: 0.789},
  #    }
  def proficient_by_race_or_ethnicity(race)
    val_races = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
    raise UnknownDataError.new("Not a valid race") if !val_races.include?(race)
  # collect all in a hash
    # iterate through math, reading, writing.
    converted_hash = {}
    {:math => @math, :reading => @reading,:writing => @writing}.each do |subject_key, subject_hash|
      subject_hash.each_pair do |key, hash|
        # binding.pry
          # converted_hash.merge(converted_hash[key] = {subject_key => truncate(hash[race])})
          converted_hash.merge!({key => {subject_key => truncate(hash[race])}}) { |k, x, y| x.merge(y) }
      end
      # binding.pry

    end
    converted_hash
    #   for each key - val pair, truncate(grab value) of race arg.
    #   set key to :instance_var => truncated

  end
# @math={2011=>{:"all students"=>0.68, :asian=>0.816, :black=>0.424, :"hawaiian/pacific islander"=>0.568, :hispanic=>0.568, :"native american"=>0.614, :"two or more"=>0.677, :white=>0.706}, 2012=>{:"all students"=>0.689, :asian=>0.818, :black=>0.424, :"hawaiian/pacific islander"=>0.571, :hispanic=>0.572, :"native american"=>0.571, :"two or more"=>0.689, :white=>0.713}, 2013=>{:"all students"=>0.696, :asian=>0.805, :black=>0.44, :"hawaiian/pacific islander"=>0.683, :hispanic=>0.588, :"native american"=>0.593, :"two or more"=>0.696, :white=>0.72}, 2014=>{:"all students"=>0.699, :asian=>0.8, :black=>0.42, :"hawaiian/pacific islander"=>0.681, :hispanic=>0.604, :"native american"=>0.543, :"two or more"=>0.693, :white=>0.723}}



# @third_grade={2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671}, 2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706}, 2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662}, 2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678}, 2012=>{:reading=>0.87, :math=>0.83, :writing=>0.655}, 2013=>{:math=>0.855, :reading=>0.859, :writing=>0.668}, 2014=>{:math=>0.834, :reading=>0.831, :writing=>0.639}}


  # def proficient_for_subject_by_grade_in_year(subject, grade, year)
  #
  # end
  #


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
