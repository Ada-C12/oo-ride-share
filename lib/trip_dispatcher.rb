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
    
    private
    
    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect_passenger(passenger)
        driver = find_driver(trip.driver_id)
        trip.connect_driver(driver)
      end
      return trips
    end
    
    #Wave 3 
    def request_trip(passenger_id)
      # Your code should automatically assign a driver to the trip
      # For this initial version, choose the first driver whose status is :AVAILABLE
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          driver = assigned_driver
        end 
        return assigned_driver 
      end 
      # Your code should use the current time for the start time
      start_time = Time.new
      # The end date, cost and rating will all be nil
      end_time = nil
      cost = nil
      rating = nil
      id = @trips.last.id + 1
      # Create a new instance of Trip
      requested_trip = Trip.new(id: id, passenger: nil, passenger_id: passenger_id,
        start_time: start_time, end_time: end_time, rating: rating, driver_id: assigned_driver.id, driver: assigned_driver)
        # Modify this selected driver using a new helper method in Driver:
        # Add the new trip to the collection of trips for that Driver
        # Set the driver's status to :UNAVAILABLE
        assigned_driver.requested_driver_helper(requested_trip)
        # Add the Trip to the Passenger's list of Trips
        requesting_passenger = find_passenger(passenger_id)
        requesting_passenger.add_trip(requested_trip)
        # Add the new trip to the collection of all Trips in TripDispatcher
        @trips << requested_trip
        # Return the newly created trip
        return requested_trip
      end
    end
  end
end 