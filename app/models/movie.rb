class Movie < ActiveRecord::Base
    has_many :vhs
    has_many :movie_genres
    has_many :genres, through: :movie_genres
    has_many :rentals, through: :vhs
    
    def self.available_now
        Vhs.available_now.map(&:movie).uniq
    end

    def movie_clients
        self.rentals.map(&:client)
    end

    def self.most_clients
        movies_hash = self.all.each_with_object({}) { |movie, movie_hash| movie_hash[movie] = movie.movie_clients.uniq.count }
        movies_hash.max_by {|movie, client_count| client_count}[0]
    end
end