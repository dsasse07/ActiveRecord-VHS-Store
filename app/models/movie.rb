class Movie < ActiveRecord::Base
    has_many :vhs
    has_many :movie_genres
    has_many :genres, through: :movie_genres
end