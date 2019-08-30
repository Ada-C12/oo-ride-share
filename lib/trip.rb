require 'csv'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver_id, :driver   
    
    def initialize(id:,
      passenger: nil, passenger_id: nil,
      start_time:, end_time: nil, cost: nil, rating:, driver_id: nil, driver: nil)
      super(id)
      
      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError, 'Passenger instance or passenger_id is required'
      end
      
      # Evaluate Time obj args from .from_csv  
      if end_time == nil
        # trip has not ended yet, still valid as nil
        @start_time = start_time
      elsif end_time >= start_time
        @start_time = start_time
        @end_time = end_time
      else
        raise ArgumentError, "Start_time has to be before end-time"
      end
      
      @cost = cost
      
      # @rating may be nil for ongoing trips
      @rating = rating
      if @rating    
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
      
      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, 'Driver instance or driver_id is required'
      end
      
    end
    
    def inspect   
      # formats what's returned when typing... p <TripInstanceName>
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end
    
    def connect(driver, passenger)
      # given known Passenger and Driver instances, add this Trip instance to each person's @trips array
      
      # update this Trip instance's @driver & @passenger
      @driver = driver
      @passenger = passenger
      
      # update each person instance's @trips
      passenger.add_trip(self)
      driver.add_trip(self)
    end
    
    def duration
      if @end_time
        return (@end_time - @start_time)
      else
        raise ArgumentError, "trip has not ended yet"
      end
    end
    
    private
    
    def self.from_csv(record)
      # looks at the arg hash record = {id:xxx, passenger:xxx, passenger_id:xxx, start_time:xxx, end_time:xxx, cost:xxx, rating:xxx}
      # returns Trip.new() object with args above
      
      # change the time Strings into Time objects             
      start_time_parsed = Time::parse(record[:start_time])  
      if record[:end_time]
        end_time_parsed = Time::parse(record[:end_time])        
      else  
        # currently active trips will have end_time = nil 
        end_time_parsed = nil
      end
      
      return self.new(
        id: record[:id],
        passenger_id: record[:passenger_id],
        start_time: start_time_parsed,     
        end_time: end_time_parsed,          
        cost: record[:cost],
        rating: record[:rating],
        driver_id: record[:driver_id]      
      )
    end
  end
end
