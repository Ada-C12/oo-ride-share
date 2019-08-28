require "csv"
require "time"

require_relative "passenger"
require_relative "trip"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: "./support")
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def self.request_trip(passenger_id)
      # create a new trip (Trip.new(id, passenger_id, driver_id, start_time: Time.now, end_time: nil, cost: nil, rating: nil))
      # Use find method to find first driver who is AVAILABLE
      # Create helper method in Driver class
      # Use series of conditional statements to check if Driver is available. If so, use change_status method to change to UNAVAILABLE
      passenger = find_passenger(passenger_id)
      available_driver = drivers.find { |driver| driver.status == :AVAILABLE }
      if available_driver == nil
        raise ArgumentError.new "There are no available drivers!"
      end

      start_time = Time.now
      end_time = nil
      cost = nil
      rating = nil

      current_trip = RideShare::Trip.new(
        id: 8,
        passenger_id: passenger,
        driver_id: available_driver.id,
        start_time: start_time,
        end_time: end_time,
        cost: cost,
        rating: rating,
      )

      passenger.add_trip(current_trip)
      available_driver.add_trip(current_trip)
      @trips << current_trip
      available_driver.change_status
      return current_trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end

      return trips
    end
  end
end
