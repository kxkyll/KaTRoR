module CalculateAverage
    def average_rating
        #ratings.average('score')
        ratings.inject(0) { |sum, s| sum + s.score } / ratings.count
    end
end