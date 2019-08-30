require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord 
    
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @status = status
      @trips = trips || []
      
      if vin.length == 17
        @vin = vin 
      else
        raise ArgumentError
      end
    end
    
    
    def add_trip(trip)
      @trips << trip
    end
    
    # Each 'driver' object in it contains an array of objects 'trips'
    # Inside of 'trips' there is the rating
    # Loop throuh each the cost in the trip and sum it, and divide that by the length
    # Account for if length is zero, so we don't get divide by zero error 
    
    def average_rating
      rating_sum = 0
      if @trips.length > 0
        @trips.each.map do |trip|
          rating_sum += trip.rating
        end
        total_rating = (rating_sum.to_f / trips.length.to_f)
        total_rating = total_rating.to_f
        puts total_rating
        return total_rating
      elsif @trips == []
        return 0
      end 
    end
    
    # This method calculates that driver's total revenue across all their trips. 
    # Each driver gets 80% of the trip cost after a fee of $1.65 per trip is subtracted. 
    # What if there are no trips?What if the cost of a trip was less that $1.65?                                                            |
    def total_revenue 
      if @trips.length > 0 
        revenue = @trips.map do |trip|
          (trip.cost - 1.65) * 0.8 
        end 
        revenue.sum
      elsif @trips.length == 0 
        return 0 
      end 
    end 
    
    def trip_updater(trip)
      add_trip(trip)
      
      @status = :UNAVAILABLE 
    end


    # Since `Driver` inherits from `CsvRecord`, you'll need to implement the `from_csv` template method. Once you do, `Driver.load_all` should work (test this in pry).
    private 
    
    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym,
        trips: record[:trips]
      )
    end
  end
end




