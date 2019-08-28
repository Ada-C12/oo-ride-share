require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    STATUSES = [:AVAILABLE, :UNAVAILABLE]
    TRIP_FEE = 1.65
    PERCENTAGE_PAY = 0.8
    
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      
      @name = name
      @vin = vin
      @status = status
      @trips = trips
      
      if @vin.length != 17
        raise ArgumentError.new("VIN must contain 17 characters")
      end
      
      if !STATUSES.include? @status
        raise ArgumentError.new("Invalid status")
      end
    end  
    
    def add_trip(trip)
      if !trip.instance_of? Trip
        raise ArgumentError.new("Input must be an instance of Trip")
      end
      
      @trips << trip
    end
    
    def total_revenue
      revenue_minus_trip_fee = @trips.sum do |trip|
        trip.cost <= TRIP_FEE ? trip.cost : trip.cost - TRIP_FEE
      end
      total_revenue = revenue_minus_trip_fee * PERCENTAGE_PAY
      return total_revenue.round(2)      
    end
    
    def average_rating
      total_rating = @trips.sum { |trip| trip.rating }
      number_of_trips = @trips.length
      average_rating = (number_of_trips == 0) ? 0 : total_rating/number_of_trips.to_f
      return average_rating.round(1)
    end
    
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