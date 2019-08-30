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
      @drivers = Driver.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
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
      passenger = @passengers.find {|passenger| passenger.id == passenger_id }
      driver = @drivers.find {|driver| driver.status == :AVAILABLE }
      id = @trips.last.id + 1
      trip = RideShare::Trip.new(id: id, passenger_id: passenger_id, start_time: Time.now, end_time: nil, rating: nil, driver_id: driver.id)
      driver.status = :UNAVAILABLE
      trip.connect(driver)
      trip.connect(passenger)
      
      return trip
      
    end
    
    private
    
    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger)
        trip.passenger = passenger
        driver = find_driver(trip.driver_id)
        trip.connect(driver)
        trip.driver = driver
      end
      return @trips
    end
    
  end
end
