require "csv"
require "time"

require_relative "csv_record"

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :duration, :driver, :driver_id

    def initialize(id:, driver: nil, driver_id: nil,
                   passenger: nil, passenger_id: nil,
                   start_time:, end_time:, cost: nil,
                   rating:)
      super(id)

      if start_time > end_time
        raise ArgumentError.new("Start time after end time")
      end
      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError, "Passenger or passenger_id is required"
      end
      @driver = driver
      @driver_id = driver_id
      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating
      @duration = duration
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

    def connect_driver(driver)
      @driver = driver
      driver.add_trip(self)
    end

    def duration_in_seconds(start_time, end_time)
      set_end = ()
      set_start = ()
      set_end = Time.parse(end_time)
      set_start = Time.parse(start_time)
      duration = set_end - set_start
      return duration.to_i
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id].to_i,
               driver_id: record[:driver_id].to_i,
               passenger_id: record[:passenger_id].to_i,
               start_time: Time.parse(record[:start_time]),
               end_time: Time.parse(record[:end_time]),
               cost: record[:cost],
               rating: record[:rating],
             )
    end
  end
end
