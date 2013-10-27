class User < ActiveRecord::Base
  include CalculateAverage
  attr_accessible :username, :password, :password_confirmation
  has_secure_password
  validates_uniqueness_of :username
  validates_length_of :username, :minimum => 3, :maximum => 15
  validates_length_of :password, :minimum => 4
  validates_format_of :password, :with => /[0-9]+/

  has_many :ratings, :dependent => :destroy
  has_many :beers, :through => :ratings
  has_many :memberships
  has_many :beer_clubs, :through => :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by{|r| r.score}.last.beer
  end

  def favorite_style
  end

  def favorite_brewery
  end

  def to_s
    "#{username}" 
      
  end
end
