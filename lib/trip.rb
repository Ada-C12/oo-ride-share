require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :driver, :driver_id, :start_time, :end_time, :cost, :rating
    
    def initialize(
      id:,
      passenger: nil, 
      passenger_id: nil,
      driver: nil,
      driver_id: nil,
      start_time:, 
      end_time:, 
      cost: nil, 
      rating:
      )
      
      super(id)
      
      validate_input(object: passenger, 
      object_id: passenger_id)
      if passenger
        @passenger = passenger
        @passenger_id = passenger.id  
      else
        @passenger_id = passenger_id
      end
      
      validate_input(object: driver, 
      object_id: driver_id)
      if driver
        @driver = driver
        @driver_id = driver.id  
      else
        @driver_id = driver_id
      end
      
      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating
      
      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
      
      if @end_time < @start_time
        raise ArgumentError.new("End time is before the start time")
      end
      
    end
    
    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end
    
    def connect(passenger, driver)
      @passenger = passenger
      passenger.add_trip(self)
      @driver = driver
      driver.add_trip(self)
    end
    
    def duration
      return @end_time - @start_time
    end
    
    private
    
    def self.from_csv(record)
      return self.new(
      id: record[:id],
      passenger_id: record[:passenger_id],
      driver_id: record[:driver_id],
      start_time: Time.parse(record[:start_time]),
      end_time: Time.parse(record[:end_time]),
      cost: record[:cost],
      rating: record[:rating]
      )
    end
    
    def validate_input(object: , object_id:)
      # validating input object and input object id
      if !object && !object_id
        raise ArgumentError, "Input object or object id is required"
      end
    end
    
  end
end