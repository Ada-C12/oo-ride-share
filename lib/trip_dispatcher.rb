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
    
    def find_avail_drivers
      avail_drivers = []
      
      @drivers.each do |driver|
        avail_drivers << driver if driver.status == :AVAILABLE
      end
      return avail_drivers
    end
    
    def find_next_driver
      next_driver = nil
      
      find_avail_drivers.each do |driver|
        if driver.trips.length == 0
          next_driver = driver
          break
        end
      end
      
      if next_driver == nil
        last_trip_overall = Time.now
        
        find_avail_drivers.each do |driver|
          driver_trip_end = [] 
          
          driver.trips.each do |trip|
            driver_trip_end << trip.end_time
          end
          
          if driver_trip_end.max < last_trip_overall 
            last_trip_overall = driver_trip_end.max
            next_driver = driver
          end
        end
      end
      return next_driver
    end
    
    def request_trip(passenger_id)
      requested_trip_id = @trips.length + 1
      driver = find_next_driver
      
      if driver == nil 
        raise ArgumentError.new("There are no drivers available.")
      end
      
      passenger = find_passenger(passenger_id)
      
      trip = Trip.new(
        id: requested_trip_id,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: driver,
      )
      
      driver.add_trip(trip)
      driver.set_status_unavailable
      passenger.add_trip(trip)
      
      return trip
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
