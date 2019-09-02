require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips, :status
    
    def initialize(id:, name:, vin:, trips: nil, status: :AVAILABLE)
      super(id)
      
      @name = name
      @vin = vin
      @trips = trips || []
      @status = status.to_sym
      
      if @vin.length != 17
        raise ArgumentError.new("The vin must be 17 characters long")
      end
      
      # raise argument errors for driver statuses that aren't available or unavailable
      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise ArgumentError.new("Please choose between AVAILABLE OR UNAVAILABLE")
      end
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      total = 0.0
      if trips.length == 0
        return 0
      end
      trips.each do |trip|
        if trip.rating != nil
          total += trip.rating 
        end
      end
      return total / trips.length
    end
    
    def total_revenue
      
      # Pull trip costs out of driver's trips array 
      gross_revenue_array = []
      trips.each do |trip|
        if trip.cost != nil
          gross_revenue_array << trip.cost
        end
      end
      
      # Multiply number of trips by trip fee ($1.65)
      total_fees = gross_revenue_array.length * 1.65
      
      # Subtract total fees from gross revenue, then return 80% of that
      driver_earnings = (gross_revenue_array.sum - total_fees) * 0.80
      
      return driver_earnings
    end
    
    # helper method for trip dispatcher request_trip method that ...
    def driver_helper(new_trip)
      # ... adds the newly requested trip to the collection of trips for that driver
      @trips << new_trip
      # ... and sets the driver's status to :UNAVAILABLE
      @status = :UNAVAILABLE
    end
    
    def self.from_csv(record)
      return self.new(id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end