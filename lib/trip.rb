require 'csv'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver_id, :driver
    
    def initialize(id:,
      passenger: nil, passenger_id: nil,
      start_time:, end_time:, cost: nil, rating:, driver_id: , driver:)
      super(id)
      
      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
        
      elsif passenger_id
        @passenger_id = passenger_id
        
      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end
      
      if end_time != nil
        if end_time < start_time
          raise ArgumentError, "End time #{end_time} is before the start time #{start_time}"
        end 
      end
      
      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating
      @driver_id = driver_id
      @driver = driver
      
      if @rating != nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
    end 
    
    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end
    
    def connect(passenger)
      raise ArgumentError.new "passenger is invalid." if passenger == nil || passenger.class != Passenger
      @passenger = passenger
      passenger.add_trip(self)
    end
    
    def connect_driver(driver)
      raise ArgumentError.new "driver is invalid." if driver == nil || driver.class != Driver
      @driver = driver
      driver.add_trip(self)
    end
    
    def duration
      if end_time == nil 
        return 0
      else
        return @end_time - @start_time
      end
    end 
    
    private
    
    def self.from_csv(record)
      start_time = Time.parse(record[:start_time])
      end_time = Time.parse(record[:end_time])
      
      return self.new(
        id: record[:id],
        passenger_id: record[:passenger_id],
        start_time: start_time,
        end_time: end_time,
        cost: record[:cost],
        rating: record[:rating],
        driver_id: record[:driver_id],
        driver: nil
      )
    end
  end
end
