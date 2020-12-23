class Rental < ActiveRecord::Base
    belongs_to :client
    belongs_to :vhs
end