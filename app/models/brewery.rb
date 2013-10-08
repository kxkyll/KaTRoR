class Brewery < ActiveRecord::Base
  include CalculateAverage
  validate :year_must_be_between_1042_and_this_year

  attr_accessible :name, :year
  has_many :beers
  has_many :ratings, :through => :beers

  validates_presence_of :name
  #validates_numericality_of :year,    {:greater_than_or_equal_to => 1042,
                                        #:less_than_or_equal_to => Time.new.year,
                                        #:only_integer => true}
  
    
  validates_numericality_of :year,    {:only_integer => true}
  def year_must_be_between_1042_and_this_year
    if year.present? && year < 1042 || year.present? && year > Time.new.year
       errors.add(:year, "must be equal or between 1042 and this year")
    end
  end
  
end
