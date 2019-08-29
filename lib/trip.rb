require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger_id, :start_time, :end_time, :cost, :rating, :driver_id
    attr_accessor :driver, :passenger
    
    def initialize(id:,passenger: nil, passenger_id: nil, start_time:, end_time:, cost: nil, rating:, driver: nil, driver_id: nil)
      super(id)
      
      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
        
      elsif passenger_id
        @passenger_id = passenger_id
        
      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end
      
      if end_time.to_f > start_time.to_f
        @start_time = start_time
        @end_time = end_time
      else
        raise ArgumentError.new("Trip length of time is invalid")
      end
      
      @cost = cost
      @rating = rating
      
      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
      
      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, 'Driver or driver_id is required'
      end
      
    end
    
    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end
    
    # I AM A BROKEN METHOD!!!!!
    def connect(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end
    
    def connect(driver)
      @driver = driver
      driver.add_trip(self)
    end
    
    def duration
      duration = @end_time - @start_time
      return duration
    end
    
    private
    
    def self.from_csv(record)
      return self.new(
        id: record[:id],
        driver_id: record[:driver_id],
        passenger_id: record[:passenger_id],
        start_time: Time.parse(record[:start_time].to_s),
        end_time: Time.parse(record[:end_time].to_s),
        cost: record[:cost],
        rating: record[:rating]
      )
    end
  end
end

