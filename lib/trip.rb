require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver, :driver_id
    
    def initialize(id:,
      passenger: nil, passenger_id: nil,
      start_time:, end_time:, cost: nil, rating:, driver: nil, driver_id: nil)
      super(id)
      
      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
        
      elsif passenger_id
        @passenger_id = passenger_id
        
      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end
      
      if driver
        @driver = driver
        @driver_id = driver.id
        
      elsif driver_id
        @driver_id = driver_id
        
      else
        raise ArgumentError, 'Driver or driver_id is required'
      end
      
      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating
      
      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
      
      if @end_time < @start_time
        raise ArgumentError
      end 
      
    end
    
    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end
    
    def connect(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end
    
    def calculate_duration 
      start_time_seconds = @start_time.hour * 3600 + @start_time.min * 60 + @start_time.sec 
      
      end_time_seconds = @end_time.hour * 3600 + @end_time.min * 60 + @end_time.sec 
      
      end_time_seconds - start_time_seconds 
      
    end 
    private
    
    def self.from_csv(record)
      
      parsed_start_time = Time.parse(record[:start_time])
      parsed_end_time = Time.parse(record[:end_time])
      
      return self.new(
      id: record[:id],
      passenger_id: record[:passenger_id],
      start_time: parsed_start_time,
      end_time: parsed_end_time,
      cost: record[:cost],
      rating: record[:rating],
      driver_id: record[:driver_id]
      )
    end
    
    
  end
end
