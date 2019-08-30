require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative "driver"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips
    
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
    
    def select_driver
      available_drivers = @drivers.select do |driver|
        driver.status == :AVAILABLE
      end
      
      new_driver = available_drivers.find do |driver|
        driver.trips.empty?
      end
      return new_driver if new_driver
      
      oldest_trip_driver = available_drivers.min_by do |driver|
        driver.trips.max_by do |trip|
          trip.end_time
        end
      end
      return oldest_trip_driver
    end
    
    def request_trip(passenger_id)
      id = @trips.count + 1
      driver = select_driver
      
      if !driver
        raise ArgumentError.new("There are no available drivers.")
      end
      
      passenger = find_passenger(passenger_id)
      start_time = Time.now
      
      new_trip = Trip.new(id: id, driver: driver, passenger: passenger, start_time: start_time)
      
      driver.start_trip(new_trip)
      passenger.add_trip(new_trip)
      @trips << new_trip
      return new_trip
    end
    
    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
      #{trips.count} trips, \
      #{drivers.count} drivers, \
      #{passengers.count} passengers>"
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
