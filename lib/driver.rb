require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    STATUSES = [:AVAILABLE, :UNAVAILABLE]
    
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