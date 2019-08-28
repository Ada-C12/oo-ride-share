# driver.rb

require_relative 'csv_record'
require_relative 'trip'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
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