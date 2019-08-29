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
      assigned_driver = @drivers.find { |driver| driver.status == :AVAILABLE } 
      if assigned_driver == nil 
        raise ArgumentError, "Sorry, all drivers are at a painting conference."
      end 
      start_time = Time.new
      end_time = nil
      rating = nil
      id = @trips.length + 1
      requested_trip = Trip.new(id: id, passenger_id: passenger_id, start_time: start_time, end_time: end_time, rating: rating, driver_id: assigned_driver.id, driver: assigned_driver)
      assigned_driver.requested_driver_helper(requested_trip)
      requested_trip.connect_passenger(find_passenger(passenger_id))
      @trips << requested_trip
      return requested_trip
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
  end  
end 
