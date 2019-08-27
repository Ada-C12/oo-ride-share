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
        total_ratings += one_trip.rating
      end
      return trips.length == 0 ? 0 : (total_ratings.to_f/trips.length)
      
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
