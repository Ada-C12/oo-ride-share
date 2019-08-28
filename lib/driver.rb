require 'csv'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      
      if vin.length != 17
        raise ArgumentError.new("Invalid VIN input.")
      else
        @vin = vin
      end
      
      if status == :AVAILABLE || status == :UNAVAILABLE
        @status = status
      else
        raise ArgumentError.new("Invalid status.")
      end
      
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      total_rating = 0
      
      if trips.length == 0
        return 0
      else
        trips.each do |trip|
          total_rating += trip.rating
        end
        
        avg_rating = total_rating.to_f / trips.length
        return avg_rating.round(1)
        
      end
    end
    
    def total_revenue
      total_revenue = 0
      
      trips.each do |trip|
        if trip.cost < 1.65
          total_revenue += 0
        else
          total_revenue += (trip.cost - 1.65) * 0.8
        end
      end
      
      return total_revenue.round(2)
    end
    
    private
    
    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end

