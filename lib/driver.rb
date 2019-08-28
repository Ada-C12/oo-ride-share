require_relative 'csv_record'

###JULIA### entire file added for Wave2

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      # using superclass CsvRecord's initialize() to validate id
      super(id)
      
      @name = name
      
      if vin.class == String && vin.length == 17
        @vin = vin
      else
        raise ArgumentError, "VIN must be string of length 17"
      end
      
      @status = status.to_sym
      @trips = trips || []
    end
    
    ###JULIA### ADDED for Wave2: Loading Drivers
    def add_trip(trip)
      @trips << trip
    end
    
    ###JULIA### ADDED for Wave2: Driver Methods
    def average_rating
      # Assigns @average_rating of all trips, rounded to 2 places.  Or zero if no trips yet.
      
      ratings_sum = trips.sum do |trip_instance|
        trip_instance.rating
      end
      
      if trips.length != 0
        return (ratings_sum.to_f/trips.length).round(2)
      else  
        return 0
      end
    end
    
    ###JULIA### ADDED for Wave2: Driver Methods
    def total_revenue
      # This method calculates that driver's total revenue across all their trips. 
      # Each driver gets 80% of the trip cost AFTER a fee of $1.65 per trip is subtracted
      # What if there are no trips?   => zero
      # What if the cost of a trip was less that $1.65? => zero
      
      total_revenue = 0.0
      trips.each do |trip_instance|
        cost = trip_instance.cost
        total_revenue += (cost - 1.65) * 0.8
      end
      
      return total_revenue.round(2)
    end
    
    
    
    
    
    
    
    
    
    
    
    
    private
    
    def self.from_csv(record)
      # looks at the arg hash record = {id:xxx, name:xxx, vin:xxx, status:XXX}
      # returns Trip.new() object with args above and default nil on trips
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status:record[:status]
      )
    end
  end
end
