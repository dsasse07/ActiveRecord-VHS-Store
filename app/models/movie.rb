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

    def self.most_rentals
        vhs_hash = Vhs.count_vhs_by_client
        movie_by_client_count = vhs_hash.each_with_object({}) do |(vhs, times_rented), movie_hash|
                movie_hash[vhs.movie].nil? ? movie_hash[vhs.movie] = times_rented : movie_hash[vhs.movie] += times_rented
        end
        movie_by_client_count.sort_by(&:last).pop(3).to_h.keys
    end
    
end