require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      
      if vin.length != 17
        raise ArgumentError.new("The VIN must be 17 characters.")
      end
      
      @vin = vin
      
      if status != :AVAILABLE && status != :UNAVAILABLE
        raise ArgumentError.new("The driver status must be available or unavailable.")
      end
      
      @status = status
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def start_trip(trip)
      add_trip(trip)
      @status = :UNAVAILABLE
    end
    
    def average_rating
      ratings = []
      
      @trips.each do |trip|
        ratings.push(trip.rating) if trip.rating
      end
      
      return nil if ratings.length == 0
      
      average_rating = ratings.sum / ratings.length.to_f
      return average_rating
    end
    
    def total_revenue
      total_revenue = 0
      
      @trips.each do |trip|
        if trip.cost
          net_cost = trip.cost - 1.65
          if net_cost > 0
            total_revenue += (net_cost * 0.8).round(2)
          end
        end
      end
      
      return total_revenue
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
