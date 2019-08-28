# Wave 2
require_relative 'csv_record'
require 'pry'

module RideShare
  # inherits from CsvRecord (similar to Trip & Passenger)
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      # Pass to the superclass constructor (CsvRecord) similar to Passenger
      super(id)
      @name = name
      
      if vin.length != 17
        raise ArgumentError
      else
        @vin = vin
      end
            
      valid_status = %i[AVAILABLE UNAVAILABLE]
      if valid_status.include?(status)
        @status = status
      else
        raise ArgumentError
      end
      
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips.length == 0
        return 0
      else
        avg_rating = 0
        @trips.each do |trip|
          avg_rating += trip.rating
        end

        avg_rating = (avg_rating/@trips.length).to_f.round(2)
        return avg_rating
      end
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
