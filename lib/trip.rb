require 'csv'
require 'time'

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
      
      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating
      
      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
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
    
    # duration method
    # instance method, difference between start time and end time
    # def duration
    #   difference = end - start
    #   IF difference is less than or equal to zero
    #     raise argument error
    #   END
    # end
    def duration
      difference = end_time - start_time
      if difference == 0
        raise ArgumentError.new("Duration cannot be zero")
      end
      return difference
    end
    
    private
    
    def self.from_csv(record)
      # Modify Trip.from_csv to turn start_time and end_time into Time instances before passing them to Trip#initialize
      
      # START => 2018-12-27 02:39:05 -0800
      # END => 2018-12-27 03:38:08 -0800
      start_time = Time.parse(record[:start_time])
      end_time = Time.parse(record[:end_time])
      
      return self.new(
        id: record[:id],
        passenger_id: record[:passenger_id],
        start_time: record[:start_time],
        end_time: record[:end_time],
        cost: record[:cost],
        rating: record[:rating]
      )
    end
  end
end

# duration = end_time - start_time