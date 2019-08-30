require_relative 'csv_record'


module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      
      unless vin.length == 17
        raise ArgumentError, "Invalid vin number."
      end
      
      @name = name
      @vin = vin
      @status = status
      @trips = trips || []
      
      
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      average_rating = 0
      
      @trips.each do |trip|
        average_rating += trip.rating 
      end
      
      if @trips.length == 0
        average_rating = 0
        return average_rating
      else 
        average_rating = average_rating/ @trips.length
        return average_rating.to_f.round(1)
      end
    end
    
    def total_revenue
      total_revenue = 0
      
      if @trips.length == 0
        return 0
      end
      
      @trips.each do |trip|
        if trip.cost <= 1.65
          total_revenue += 0
        else
          driver_amount = trip.cost - 1.65
          total_revenue += (driver_amount * 0.80) 
        end
      end
      return total_revenue.to_f.round(2)
    end
    
    def update_driver(in_progress_trip)
      self.status = :UNAVAILABLE
      @trips << in_progress_trip
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