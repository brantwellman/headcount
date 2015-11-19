require_relative "district"
require_relative 'enrollment_repository'
require_relative 'statewidetest_repository'
require 'pry'

class DistrictRepository
  attr_accessor :districts, :enrollment_repository, :statewidetest_repository

  def initialize
    @districts = []
    @enrollment_repository = EnrollmentRepository.new
    @statewidetest_repository = StatewideTestRepository.new
  end

  def load_data(hash)
    @enrollment_repository.load_data(:enrollment => hash[:enrollment])
    @statewidetest_repository.load_data(:statewide_testing => hash[:statewide_testing])
    load_repos({
      :enrollment => @enrollment_repository,
      :statewide_testing => @statewidetest_repository
    })
  end

  def load_repos(repos)
    repos.each do |key, repo|
      add_to_districts_from_repositories(key, repo)
    end
  end

  def add_to_districts_from_repositories(key, repository)
    district_names = repository.send(key.to_s + "s").map(&:name).uniq
    district_names.map do |name|
      district = find_by_name(name)
      if district.nil?
        district = District.new({name: name})
        district.send("set_" + key.to_s, repository.find_by_name(district.name))
            @districts << district
      else
        district.send("set_" + key.to_s, repository.find_by_name(district.name))
      end
    end
  end

  def find_by_name(district_name)
    @districts.find {|district| district.name == district_name.upcase }
  end

  def find_all_matching(str_fragment)
    @districts.select { |district| district.name.include?(str_fragment.upcase)}
  end
end
