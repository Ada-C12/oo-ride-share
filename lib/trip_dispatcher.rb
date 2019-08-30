require 'csv'
require 'time'

require_relative 'driver'
require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips
    
    def initialize(directory: './support')
      @drivers = Driver.load_all(directory: directory)
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      connect_trips
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end
    
    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end
    
    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
      #{trips.count} trips, \
      #{drivers.count} drivers, \
      #{passengers.count} passengers>"
    end
    
    def request_trip(passenger_id)
      id = 0
      last_trip_id = self.trips.last.id
      id = last_trip_id + 1
      
      current_driver = nil
      
      drivers.each do |driver|
        if driver.status == :AVAILABLE
          current_driver = driver
          break
        end
      end
      if current_driver.nil?
        raise ArgumentError.new("No available drivers.")
      end
      
      passenger = self.find_passenger(passenger_id)
      if passenger.nil?
        raise ArgumentError.new("Invalid passenger id #{passenger_id}")
      end
      
      new_trip = Trip.new(id: id, driver: current_driver, passenger: passenger, start_time: Time.now, end_time: nil, rating: nil)
      
      new_trip.driver.add_trip(new_trip)
      
      new_trip.driver.status = :UNAVAILABLE
      
      passenger.add_trip(new_trip)
      
      add_trip(new_trip)
      
      return new_trip 
    end
    
    private
    
    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(driver, passenger)
      end
      
      return trips
    end
  end
end
