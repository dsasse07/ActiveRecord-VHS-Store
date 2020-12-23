class Rental < ActiveRecord::Base
    belongs_to :client
    belongs_to :vhs

    #Rental.create(current: true, created_at: (DateTime.now - 50.days), client_id: 4, vhs_id: 45)

    def due_date
        # binding.pry
        self.created_at + 7.days
    end

    def self.past_due_date
        self.all.select do |rental| 
            rental.past_due? || rental.returned_late?
        end
    end

    def past_due?
        self.current == true && self.due_date < DateTime.now
    end

    def returned_late?
        self.current == false && self.due_date < self.updated_at
    end
end