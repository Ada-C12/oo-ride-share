require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status
    
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
          if trip.end_time != nil
            trip_ratings << trip.rating
          end 
        end
        
        total_rating = trip_ratings.sum
        return average_rating = total_rating.to_f / trip_ratings.length 
      end 
    end 
    
    def calculate_total_revenue 
      trip_costs = []
      
      trips.each do |trip|
        if trip.end_time
          trip_costs << (trip.cost - 1.65)
        end
      end
      total_cost = trip_costs.sum
      total_revenue = total_cost * 0.8
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