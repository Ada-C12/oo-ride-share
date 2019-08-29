require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    
    attr_reader :name, :vin, :trips
    attr_accessor :status
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name 
      @trips = trips || []
      @status = status 
      
      if vin.length == 17 
        @vin = vin 
      else 
        raise ArgumentError
      end 
      
    end
    def add_trip(new_trip) 
      if new_trip.driver_id == @id 
        @trips << new_trip 
      end 
    end 
    
    def average_rating 
      if @trips.length > 0
        ratings = @trips.map do |trip|
          if trip.rating != nil
            trip.rating
          end
        end
        (ratings.sum / ratings.length).to_f
      elsif @trips.length == 0
        raise ArgumentError, "Driver has no ratings."
      end
    end 
    
    def total_revenue 
      if @trips.length > 0 
        revenue = @trips.map do |trip|
          if trip.cost != nil
            (trip.cost - 1.65) * 0.8 
          end
        end 
        revenue.sum
      elsif @trips.length == 0 
        raise ArgumentError, "Driver has no trips."
      end 
    end 
    
    def make_driver_unavailable
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