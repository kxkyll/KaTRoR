class Beer < ActiveRecord::Base
  attr_accessible :brewery_id, :name, :style
  
  belongs_to :brewery
  has_many :ratings

  def average_rating
    #ratings.average('score')
    ratings.inject(0) { |sum, s| sum + s.score } / ratings.count
    
  end
end
