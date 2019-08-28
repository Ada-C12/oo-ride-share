require 'csv'
require 'time'
require 'pry'

require_relative 'passenger'
require_relative 'driver'
require_relative 'trip'

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
    
    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
      #{trips.count} trips, \
      #{drivers.count} drivers, \
      #{passengers.count} passengers>"
    end
    
    def request_trip(passenger_id)
      requested_trip_id = @trips.length + 1
      requested_trip_driver = nil
      @drivers.each do |driver|
        if driver.status == :AVAILABLE  
          requested_trip_driver = driver
          break
        end
      end
      
      trip = Trip.new(
        id: requested_trip_id,
        passenger_id: passenger_id,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver_id: requested_trip_driver.id,
      )
    end
    
    private
    
    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger)
        drivers = find_driver(trip.driver_id)
        trip.connect_drivers(drivers)
      end
      return trips
    end
    
  end
end
