class Rental < ActiveRecord::Base
    belongs_to :client
    belongs_to :vhs

    def due_date
        # binding.pry
        self.created_at + 7.days
    end

    def self.past_due_date
        self.all.select do |rental| 
            (rental.current == true && rental.due_date < DateTime.now) || (rental.current == false && rental.due_date < rental.updated_at)
        end
        binding.pry
    end
end