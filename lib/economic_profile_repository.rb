require 'pry'
require_relative 'economic_profile'
require_relative 'economic_profile_repo_parser'

class EconomicProfileRepository
  attr_reader :economic_profiles
  attr_accessor :key

  def initialize
    @economic_profiles =  []
  end

  def load_data(hash)
    parser = EconomicProfileRepoParser.new
    parser.parse(hash).each do |arr|
      @economic_profiles << EconomicProfile.new(arr[1])
    end
  end

  def find_by_name(test_name)
    @economic_profiles.find {|profile| profile.name == test_name.upcase }
  end
end
