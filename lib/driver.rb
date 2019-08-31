require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips
    attr_writer :status
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      
      @name = name.to_s
      if vin.length == 17 
        @vin = vin.to_s
      else 
        raise ArgumentError.new("Incorrect VIN length")
      end
      
      @status = status.to_sym
      unless [:AVAILABLE, :UNAVAILABLE, "AVAILABLE", "UNAVAILABLE"].include?(@status) 
        raise ArgumentError.new("Invalid Driver Status")
      end
      @trips = trips 
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      total_rating = 0
      if @trips.length == 0
        return 0
      else
      @trips.each do |trip|
        total_rating += trip.rating 
      end
      average = (total_rating.to_f/@trips.length)
      return average
    end
    end
    
    def total_revenue
      total_revenue = 0.0
      if @trips.length == 0
        return 0.0
      else
      @trips.each do |trip|
        total_revenue += trip.cost 
      end
        if total_revenue < 1.65
          return 0.0
        else
      total_revenue = (total_revenue - 1.65) * 0.8
      return total_revenue
      end
    end
  end
    private
    
    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status],
      )
    end
  end
end
