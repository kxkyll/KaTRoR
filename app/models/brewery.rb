class Brewery < ActiveRecord::Base
  include CalculateAverage
  attr_accessible :name, :year
  has_many :beers
  has_many :ratings, :through => :beers

  validates_presence_of :name
  validates_numericality_of :year,    {:greater_than_or_equal_to => 1042,
                                        :less_than_or_equal_to => 2013,
                                        :only_integer => true}
  
end
