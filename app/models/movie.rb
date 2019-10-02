class Movie < ActiveRecord::Base
    def self.unique(attribute)
        self.uniq.pluck(attribute)
    end
    
    def self.with_ratings(ratings_filter)
        self.where({rating: ratings_filter})
    end
end
