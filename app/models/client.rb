class Client < ActiveRecord::Base
    has_many :rentals
    has_many :vhs, through: :rentals


    #Client.first_rental({name: "bob", home_address: "33 road av"}, "The Color Purple")

    def self.first_rental (client_hash, movie_title)
        new_client = Client.create(client_hash)
        movie = Movie.find_by(title: movie_title)
        vhs_copies = Vhs.where(movie_id: movie.id)
        available_copy = vhs_copies.select {|copy| copy.is_available_to_rent? || !copy.ever_rented? }.first
        Rental.create(vhs_id: available_copy.id , client_id: new_client.id, current: true)
    end

    def num_of_returned_rentals
        Rental.where(client_id: self.id, current: false).count
    end

    def self.most_active
        #get all of the clients
        #get a count of how many rental instances have their client_id
        #order them by highest number of rentals returned, and then return the top 5.
        self.all.each_with_object({}) { |client, hash| hash[client] = client.num_of_returned_rentals }.sort_by(&:last).pop(5)
    end

    # refactor later
    def favorite_genre
        genres_hash = {}
        self.rentals.each do |rental| 
            rental.vhs.movie.movie_genres.each do |movie_genre|
                genres_hash[movie_genre.genre.name].nil? ? genres_hash[movie_genre.genre.name] = 1 : genres_hash[movie_genre.genre.name] += 1 
            end
        end
        genres_hash.max_by(&:last)
    end

    def self.non_grata
        self.all.select do |client|
            binding.pry 
            client.rentals.any? { |rental| rental.returned_late? || rental.past_due? }
        end
    end

    def self.paid_most
        client_spending_hash = {}
        self.all.each do |client| 
            rented_movies_fees = (client.rentals.count * 5.35).round(2)
            late_movies_fees = (client.late_movies.count * 12.00).round(2)
            total_spent = rented_movies_fees + late_movies_fees
            client_spending_hash[client] = total_spent
        end
        c_spend_h.max_by(&:last)
        binding.pry
    end

    def late_movies
        self.rentals.select{|rental| rental.returned_late?}
    end
end