require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    
    attr_reader :name, :vin, :status, :trips
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      
      @name = name
      
      if !(vin.length == 17)
        raise ArgumentError.new("VIN is improper length")
      else
        @vin = vin
      end
      
      status_options = [:AVAILABLE, :UNAVAILABLE]
      if !(status_options.include?(status))
        raise ArgumentError.new("Inappropriate status")
      else
        @status = status
      end
      
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      total_ratings = 0
      trips.each do |one_trip|
        if one_trip.rating.nil?
          total_ratings += 0  
        else 
          total_ratings += one_trip.rating
        end
      end
      return trips.length == 0 ? 0 : (total_ratings.to_f/trips.length)
    end
    
    def total_revenue
      revenue = 0.0
      
      trips.each do |one_trip|
        if one_trip.cost.nil?
          revenue += 0
        else
          cost_minus_fee = one_trip.cost - 1.65
          if cost_minus_fee <= 0
            revenue += cost_minus_fee
          else
            trip_revenue = cost_minus_fee * 0.8
            revenue += trip_revenue
          end  
        end
      end
      return revenue.floor(2)
    end
    
    private
    
    def self.from_csv(record)
      return self.new(
        id: record[:id].to_i,
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
    
  end
end
