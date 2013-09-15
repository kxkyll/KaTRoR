class Rating < ActiveRecord::Base
  attr_accessible :beer_id, :score
  belongs_to :beer
end
