require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

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
    
    
    def find_available_driver
      drivers.each do |driver|
        if driver.status == :AVAILABLE
          return driver     
        end
      end
    end
    
    
    
    def request_trip(passenger_id)
      driver = self.find_available_driver
      passenger = self.find_passenger(passenger_id)
      new_trip = self.start_trip(driver: driver, passenger: passenger)
      driver.assign_new_trip(new_trip)
      # passenger.add_trip(new_trip)
      return new_trip
    end
    
    def start_trip(driver:, passenger:)
      current_time = Time.new
      new_id = (trips.last.id + 1)
      return Trip.new(id: new_id, passenger: passenger, driver: driver, start_time: current_time)
    end
    
    
    
    # YOU SHOULD:
    
    
    #   add the trip to the passenger's list of trips
    ##### test: was the passenger's trip list updated?
    
    #   add the new trip to the TripDispatcher's collection of all trips
    ##### test: was the tripdispatcher's trip list updated?
    
    #   return the newly-created trip
    ##### test: does the request_trip method return a trip instance?  
    
    
    # other things to test:
    #   what happens when there are no available drivers?
    
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