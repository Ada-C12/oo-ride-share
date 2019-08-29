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
    
    def request_trip(passenger_id)
      current_driver = find_available_driver
      
      # Assume new trip ID is next consecutive trip ID
      id = @trips.length + 1
      
      current_trip = Trip.new(
        id: id, 
        passenger: find_passenger(passenger_id), 
        passenger_id: passenger_id, 
        start_time: Time::now, 
        end_time: nil, 
        rating: nil, 
        driver: current_driver
      )
      
      current_driver.add_trip(current_trip)
      current_driver.change_status_to_unavailable
      current_trip.passenger.add_trip(current_trip)
      @trips << current_trip
      
      return current_trip
    end
    
    def find_available_driver
      available_drivers = @drivers.select { |driver| driver.status == :AVAILABLE }
      
      # Removes drivers who are in an in-progress trip but who's status is AVAILABLE
      available_drivers.reject! do |driver| 
        driver.trips.find { |trip| trip.end_time == nil } 
      end
      
      raise ArgumentError, "No drivers currently available" if available_drivers == []
      
      # Finds first available driver who has never driven 
      requested_driver = available_drivers.find { |driver| driver.trips.length == 0 }
      
      # If all drivers have driven finds longest idle driver
      if requested_driver == nil
        requested_driver = available_drivers.min_by do |driver| 
          # Find the individual driver's most recent trip 
          driver.trips.max_by { |ride| ride.end_time }.end_time
        end
      end
      
      return requested_driver
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
