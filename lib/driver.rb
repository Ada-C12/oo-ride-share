require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      
      @name = name
      if vin.length != 17
        raise ArgumentError, "Invalid VIN."
      end 
      @vin = vin
      
      statuses = [:AVAILABLE, :UNAVAILABLE]
      if !statuses.include?(status.to_sym)
        raise ArgumentError, "Invalid status."
      end 
      @status = status.to_sym
      
      @trips = trips || []
      
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      trip_ratings = []
      
      if self.trips.empty?
        return 0
      else
        self.trips.each do |trip|
          trip_ratings << trip.rating
        end 
        
        total_rating = trip_ratings.sum
        return average_rating = total_rating.to_f / trip_ratings.length 
      end 
    end 
    
    
    
    private
    
    def self.from_csv(record)
      return new(
      id: record[:id],
      name: record[:name],
      vin: record[:vin],
      status: record[:status]
      )
    end
    
  end 
end