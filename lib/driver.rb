require_relative 'csv_record'

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
      unless [:AVAILABLE, :UNAVAILABLE].include? @status
        raise ArgumentError, "status must be either AVAILABLE or UNAVAILABLE"
      end
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      # Assigns @average_rating of all trips, rounded to 2 places.  Or zero if no trips yet.
      ratings = @trips.map { |instance| instance.rating}
      final_ratings = ratings.reject { |num| num == nil}
      return 0.0 if final_ratings.length == 0
      
      return (final_ratings.sum(0.0)/ final_ratings.length).round(2)
    end
    
    def total_revenue
      # This method calculates that driver's total revenue across all their trips. 
      # Each driver gets 80% of the trip cost AFTER a fee of $1.65 per trip is subtracted
      
      total_revenue = 0.0
      trips.each do |trip_instance|
        cost = trip_instance.cost      
        # What if there's an ongoing trip (end-time = nil)? => no cost to add
        # What if a trip made less than $1.65?  => I don't want to penalize the driver, just zero revenue
        
        if cost && cost > 1.65
          total_revenue += (cost - 1.65) * 0.8
        end
      end
      
      return total_revenue.round(2)
    end
    
    def switch_status
      if @status == :AVAILABLE
        @status = :UNAVAILABLE
      else
        @status = :AVAILABLE
      end
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
