require "csv"
require "time"

require_relative "passenger"
require_relative "trip"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips, :assigned_driver

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

    def request_trip(passenger_id)
      assigned_driver = nil
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          assigned_driver = driver
          driver.status = :UNAVAILABLE
          break
        end
      end
      passenger = find_passenger(passenger_id)
      new_trip_id = @trips.count + 1
      trip_data = {
        id: new_trip_id,
        passenger: passenger,
        driver: assigned_driver,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
      }
      new_trip = RideShare::Trip.new(trip_data)
      assigned_driver.add_trip(new_trip)
      passenger.add_trip(new_trip)
      @trips.push(new_trip)
      return new_trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger)
        driver = find_driver(trip.driver_id)
        trip.connect_driver(driver)
      end

      return trips
    end
  end
end
