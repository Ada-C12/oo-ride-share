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
