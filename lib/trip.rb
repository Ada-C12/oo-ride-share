require 'csv'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating
    
    def initialize(id:,
      passenger: nil, passenger_id: nil,
      start_time:, end_time:, cost: nil, rating:)
      super(id)
      
      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
        
      elsif passenger_id
        @passenger_id = passenger_id
        
      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end
      
      ###JULIA### WHOLE BLOCK CHANGED, Wave 1.1.3
      # Evaluate Time obj args from .from_csv     
      if end_time > start_time
        @start_time = start_time
        @end_time = end_time
      else
        raise ArgumentError, "Start_time has to be before end-time"
      end
      
      @cost = cost
      @rating = rating
      
      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
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
    
    def connect(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end
    
    ###JULIA### ADDED BLOCK for Wave 1.1.4
    def duration
      duration_secs = end_time - start_time
      return duration_secs
    end
    
    private
    
    def self.from_csv(record)
      # looks at the arg hash record = {id:xxx, passenger:xxx, passenger_id:xxx, start_time:xxx, end_time:xxx, cost:xxx, rating:xxx}
      # returns Trip.new() object with args above
      
      ###JULIA### ADDED BLOCK for Wave 1.1.2
      # change the time Strings into Time objects             
      start_time_parsed = Time::parse(record[:start_time])    
      end_time_parsed = Time::parse(record[:end_time])        
      
      return self.new(
        id: record[:id],
        passenger_id: record[:passenger_id],
        start_time: start_time_parsed,      ###JULIA### CHANGED HERE, Wave 1.1.2
        end_time: end_time_parsed,          ###JULIA### CHANGED HERE, Wave 1.1.2
        cost: record[:cost],
        rating: record[:rating]
      )
    end
  end
end
