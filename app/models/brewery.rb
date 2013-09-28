class Brewery < ActiveRecord::Base
  include CalculateAverage
  attr_accessible :name, :year
  has_many :beers
  has_many :ratings, :through => :beers
  

  #def average_rating
  #  ratings.inject(0) { |sum, s| sum + s.score } / ratings.count
  #end
end
