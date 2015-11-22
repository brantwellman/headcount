require 'pry'
require_relative 'economic_profile' #does not yet exist
require_relative 'economic_profile_repo_parser' #does not yet exist

class EconomicProfileRepository
  attr_reader :economic_profile_repo, :key

  def initialize
    @economic_profile_repo =  []
  end

  def load_data(hash)
    parser = EconomicProfileRepoParser.new
    parser.parse.each do |arr|
      @economic_profile_repo << EconomicProfile.new(arr[1])
    end
  end

  def economic_profiles
    economic_profile_repo
  end

  def find_by_name(test_name)
    @economic_profile_repo.find {|profile| profile.name == test_name.upcase }
  end
end

  #   load_files = peal_hash_to_key_file(hash)
  #   load_files.each do |key, file|
  #     @key = key
  #     district_econonomic_profile_data = parser.parse(key, file)
  #     create_economic_profiles(district_econonomic_profile_data)
  #   end
  # end
  #
  # def peel_hash_to_key_file(hash)
  #   hash.values[0].to_a
  # end
  #
  # def create_economic_profiles(district_econonomic_profile_array)
  #   district_econonomic_profile_array.each do |hash_line|
  #     create_economic_profile(hash_line)
  #   end
  # end

  # def create_economic_profile(hash_line)
  #   method_name = "set_" + @key.to_s).to_sym
  #   if find_by_name(hash_line[:name])
  #     find_by_name(hash_line[:name]).send(method_name, hash_line[@key])
  #   else
  #     @economic_profile_repo << EconomicProfile.new(hash_line)
  #   end
  # end

  #############    test code  ##############
#
# epr = EconomicProfileRepository.new
# epr.load_data({
#   :economic_profile => {
#     :median_household_income => "./data/Median household income.csv",
#     :children_in_poverty => "./data/School-aged children in poverty.csv",
#     :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
#     :title_i => "./data/Title I students.csv"
#   }
# })
# puts epr.find_by_name("AGATE 300").inspect
# puts epr.economic_profiles.count
# # # => <EconomicProfile>
