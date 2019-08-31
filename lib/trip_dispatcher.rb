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
    
    def sort_drivers     
      drivers_available = @drivers.find_all { |driver| driver.status == :AVAILABLE}
      
      return nil if drivers_available.empty?
      
      drivers_available.sort_by! {|driver| driver.trips.length}
      least_trips_length = drivers_available.first.trips.length
      
      drivers_take_least_trips = drivers_available.select {|driver| driver.trips.length == least_trips_length}
      
      return drivers_take_least_trips.first if least_trips_length == 0
      
      drivers_take_least_trips.each do |driver|
        driver.trips.sort_by! {|trip| trip.end_time}
      end
      
      return drivers_take_least_trips.first
      
    end
    
    def request_trip(passenger_id)
      passenger = @passengers.find {|passenger| passenger.id == passenger_id }
      
      driver = sort_drivers
      if driver == nil 
        raise ArgumentError.new("No available driver was found!")
      end
      
      id = @trips.last.id + 1
      driver_id = driver.id
      
      trip = RideShare::Trip.new(id: id, passenger_id: passenger_id, start_time: Time.now, end_time: nil, rating: nil, driver_id: driver_id)
      
      driver.status = :UNAVAILABLE
      @trips << trip
      
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
