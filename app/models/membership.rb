class Membership < ActiveRecord::Base
  attr_accessible :beer_club_id, :user_id
  belongs_to :beer_club
  belongs_to :user
end
