require 'csv'
require 'time'

require_relative 'passenger'
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
    def find_first_available_driver
      @trips.each do |trip|
        if trip.driver.status == :AVAILABLE
          return trip.driver
        end
      end
    end
    
    def request_trip(passenger_id)
      driver = find_first_available_driver
      start_time = Time.now
      end_time = nil
      
      passenger = find_passenger(passenger_id)
      trip_data = {
        id: 8,
        passenger: passenger,
        start_time: start_time,
        end_time: end_time,
        cost: nil,
        rating: nil,
        driver_id: driver.id,
        driver: driver
      }
      new_trip = RideShare::Trip.new(trip_data)
      
      driver.status  = :UNAVAILABLE
      passenger.add_trip(passenger)
      @trips << new_trip
      return new_trip
    end
    
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
