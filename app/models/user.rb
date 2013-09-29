class User < ActiveRecord::Base
  include CalculateAverage
  attr_accessible :username

  has_many :ratings
end
