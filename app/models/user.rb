class User < ActiveRecord::Base
  include CalculateAverage
  attr_accessible :username, :password, :password_confirmation
  has_secure_password

  has_many :ratings, :dependent => :destroy
  has_many :beers, :through => :ratings
  has_many :memberships
  has_many :beer_clubs, :through => :memberships

  def to_s
    "#{username}" 
      
  end
end
