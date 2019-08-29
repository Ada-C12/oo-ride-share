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
    
    ###JULIA### ADDED for Wave2: Driver Methods, amended for Wave 3
    def average_rating
      # Assigns @average_rating of all trips, rounded to 2 places.  Or zero if no trips yet.
      
      ongoing_trip_exists = false
      ratings_sum = 0

      trips.each do |trip_instance|
      # What if there's an ongoing trip(end-time = nil)? => don't include the nil rating in the sum! 
        if trip_instance.rating
          ratings_sum += trip_instance.rating
        elsif (trip_instance.rating == nil) && (ongoing_trip_exists == false)
          ongoing_trip_exists = true
        elsif(trip_instance.rating == nil) && (ongoing_trip_exists == true)
          raise StandardError, "Impossible to have 2 ongoing trips at same time!"
        else
          raise StandardError, "I don't know what kind of edge case caused this... investigate!" 
        end
      end

      # What if there's an ongoing trip(end-time = nil)? => don't include that 1 trip in the average calc! 
      if (trips.length > 0) && !(ongoing_trip_exists)
        return (ratings_sum.to_f/trips.length).round(2)
      elsif (trips.length >= 2) && (ongoing_trip_exists)
        return (ratings_sum.to_f/(trips.length-1)).round(2)
      else  
        # if no trips, or only a single ongoing trip
        return 0
      end
    end
    
    ###JULIA### ADDED for Wave2: Driver Methods, amended for Wave 3
    def total_revenue
      # This method calculates that driver's total revenue across all their trips. 
      # Each driver gets 80% of the trip cost AFTER a fee of $1.65 per trip is subtracted
      # What if there are no trips?   => zero
      # What if the cost of a trip was less that $1.65? => zero
      
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
    
    ###JULIA### helper fcn for Wave 3
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
