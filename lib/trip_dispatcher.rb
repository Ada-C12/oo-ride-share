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
      cur_driver = nil
      #binding.pry
      
      # same behavior:
      # cur_driver = drivers.find { |driver| driver.status == :AVAILABLE }
      
      drivers.each do |driver|
        if driver.status == :AVAILABLE
          cur_driver = driver
          break
        end
      end
      
      return Trip.new(id: 1, driver: cur_driver, passenger_id: passenger_id, start_time: Time.now, end_time: nil, rating: 2)
      # trip id needs to be updated
      # fix rating look at trip test
      
      
      
      # STARTING REQUIREMENTS
      # passenger_id will be supplied
      # pick the first driver who is :AVAILABLE
      
      # current time = start_time
      # end_date: nil
      # cost: nil
      # rating: nil
      
      # WORK
      # create a new instance of trip
      # create a new helper method in DRIVER.RB that will:
      # - add the new trip to the collection of @trips for that driver
      # - set the driver status to :UNAVAILABLE
      # add the new trip to the passenger's list of trips 
      # add the new trip to the collection of all trips in TripDispatcher
      # return the newly created trip
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
