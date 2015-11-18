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

  # def proficient_by_grade(grade)
  #
  # end
  #
  # def proficient_by_race_or_ethnicity(race)
  #
  # end
  #
  # def proficient_for_subject_by_grade_in_year(subject, grade, year)
  #
  # end
  #
  # def proficient_for_subject_by_race_in_year(subject, race, year)
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
end
