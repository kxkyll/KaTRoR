class Beer < ActiveRecord::Base
  include CalculateAverage
  
  attr_accessible :brewery_id, :name, :style
  
  belongs_to :brewery
  has_many :ratings, :dependent => :destroy
  has_many :raters, :through => :ratings, :source => :user

  validates_presence_of :name, :style
  

  
  #def average_rating
  #  #ratings.average('score')
  #  ratings.inject(0) { |sum, s| sum + s.score } / ratings.count
  #  
  #end
  def to_s
    "#{name} #{brewery.name} " 
      
  end
end
