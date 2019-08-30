require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :passengers, :trips, :drivers

    def initialize(directory: './support')
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
      available_drivers = @drivers.select{|driver| driver.status == :AVAILABLE}
      zero_trips = available_drivers.select {|driver| driver.trips.length == 0}

      if available_drivers.length == 0
        raise ArgumentError, 'No available drivers'
      end

      if zero_trips.length == 0
        # sort the driver trips and return max end time value
        available_drivers.each do |driver|
          driver.trips.sort_by! {|trip| trip.end_time}
        end

        available_drivers.sort_by! {|driver| driver.trips.last.end_time}
        chosen_driver_id = available_drivers[0].id
        chosen_driver = find_driver(chosen_driver_id)
      else
        # assign the first zero trip driver
        chosen_driver_id = zero_trips[0].id
        chosen_driver = find_driver(chosen_driver_id)
      end

      id = @trips.length + 1
      passenger = find_passenger(passenger_id)

      trip_data = {
        id: id,
        driver_id: chosen_driver_id,
        passenger: passenger,
        passenger_id: passenger_id,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: chosen_driver
      }

      trip = Trip.new(trip_data)

      chosen_driver.status = :UNAVAILABLE
      chosen_driver.add_trip(trip)
      passenger.add_trip(trip)
      @trips << trip
      return trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect_passenger(passenger)
        trip.connect_driver(driver)
      end
      return trips
    end
  end
end
