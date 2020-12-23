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
end