require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips
    
    def initialize(id:, name:, phone_number:, trips: nil)
      # using superclass CsvRecord's initialize() to validate id
      super(id)
      
      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    ###JULIA### ADDED THIS BLOCK for Wave 1.2.1, then amended for Wave 3
    def net_expenditures
      # returns the total amount of $ that the passenger spent
      total_money_spent = 0.0
      
      @trips.each do |trip|
        # What if there's an ongoing trip (end-time = nil)? => don't add nil cost!
        if trip.cost
          total_money_spent += trip.cost
        end
      end
      
      return total_money_spent
    end
    
    ###JULIA### ADDED THIS BLOCK for Wave 1.2.2, then amended for Wave 3
    def total_time_spent
      # returns the total amount of time (in seconds) that the passenger spent
      total_time_spent = 0
      
      trips.each do |trip|
        # What if there's an ongoing trip (end-time = nil)? => don't compute duration, consider it zero!
        if trip.end_time
          duration_secs = trip.duration
          total_time_spent += duration_secs
        end
      end
      return total_time_spent.round
    end
    
    private
    
    def self.from_csv(record)
      # looks at the arg hash record = {id:xxx, name:xxx, phone_num:xxx}
      # returns Passenger.new() object with args above and default nil on trips
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
