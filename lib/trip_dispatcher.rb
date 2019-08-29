require 'csv'
require 'time'

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
      available_drivers = @drivers.find_all {|driver| driver.status == :AVAILABLE}

      if available_drivers.length == 0
        raise ArgumentError, "All drivers are currently unavailable."
      end

      driver = available_drivers.first 
      passenger = find_passenger(passenger_id)
      trip_id = @trips.last.id + 1
      
      new_trip = Trip.new(
        id: trip_id,
        passenger: passenger ,
        passenger_id: passenger_id, 
        start_time: Time.now, 
        end_time: nil, 
        cost: nil, 
        rating: nil,
        driver: driver, 
        driver_id: driver.id
      )
      
      @trips << new_trip 
      driver.make_driver_unavailable
      new_trip.connect_driver(driver)
      new_trip.connect(passenger)

      return new_trip 

    end
    
    
    private

    
    def connect_trips
      @trips.each do |trip|
        driver = find_driver(trip.driver_id)
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger)
        trip.connect_driver(driver)    
      end
 
      return trips
 
    end
  end
end
