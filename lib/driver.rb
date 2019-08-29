# driver.rb

require_relative 'csv_record'
require_relative 'trip'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      if vin.length != 17
        raise ArgumentError.new("Invalid VIN")
      end
      @status = status.to_sym
      ok_statuses = [:AVAILABLE, :UNAVAILABLE]
      if !ok_statuses.include?(status)
        raise ArgumentError.new("Invalid status")
      end
      @trips = trips || []
    end 
    
    #Similar method exists in passenger 
    def add_trip(trip)
      @trips << trip
    end
    
    #TODO
    def average_rating
      total_ratings = 0
      if trips.length == 0
        return 0
      end 
      trips.each do |trip|
        if trip.rating != nil
          total_ratings += trip.rating
        end 
      end 
      return (total_ratings / trips.length.to_f).round(2) 
    end 
    
    def total_revenue
      total_revenue = 0
      if trips.length == 0
        return 0 
      else
        @trips.each do |trip|
          gross_profit = trip.cost
          if gross_profit < 1.65
            drivers_share = gross_profit * 0.8
          else
            drivers_share = (gross_profit - 1.65) * 0.8
          end          
          total_revenue += drivers_share
        end
        return total_revenue.round(2)
      end 
    end
    
    
    # Modify this selected driver using a new helper method in Driver:
    # Add the new trip to the collection of trips for that Driver
    # Set the driver's status to :UNAVAILABLE
    
    def requested_driver_helper(requested_trip)
      @trips << requested_trip
      @status = :UNAVAILABLE 
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


