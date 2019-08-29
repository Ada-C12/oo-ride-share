require 'csv'
require 'time'
require "pry"

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
      # STARTING REQUIREMENTS
      # CHECK passenger_id will be supplied
      # CHECK pick the first driver who is :AVAILABLE
      # CHECK current time = start_time
      # CHECK end_date: nil
      # CHECK cost: nil
      # CHECK rating: nil
      
      # WORK
      # CHECK create a new instance of trip
      # CHECK add the new trip to the collection of @trips for that driver
      # CHECK set the driver status to :UNAVAILABLE
      # Generate new trip id for each new trip
      # Prevent new trip from being generate if no available drivers
      # add the new trip to the passenger's list of trips 
      # add the new trip to the collection of all trips in TripDispatcher
      # CHECK return the newly created trip
      
      current_driver = nil
      # assign the first available driver to the trip
      drivers.each do |driver|
        if driver.status == :AVAILABLE
          current_driver = driver
          break
        end
      end
      
      # if no drivers are available return nil
      # if !drivers.include?(:AVAILABLE)
      #   return nil
      # end 
      
      # create a new instance of trip
      new_trip = Trip.new(id: 1, driver: current_driver, passenger_id: passenger_id, start_time: Time.now, end_time: nil, rating: nil)
      # Add the new trip to driver's list of trips
      new_trip.driver.add_trip(new_trip)
      # Change the driver status to unavailable
      new_trip.driver.status = :UNAVAILABLE
      
      # # Add the new trip to passenger's list of trips
      # new_trip.passenger.add_trip(new_trip)
      
      # Add the new trip to the TripDispatcher's trips
      self.add_trip(new_trip)
      
      
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
