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
      return @drivers.find { |driver| driver.id == id}
    end
    
    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
      #{trips.count} trips, \
      #{drivers.count} drivers, \
      #{passengers.count} passengers>"
    end
    
    def request_trip(passenger_id)
      available_drivers = []
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          available_drivers << driver
        end
      end
      
      if available_drivers.empty?
        raise ArgumentError.new "Error! There are no available drivers :("
      end
      
      new_trip = RideShare::Trip.new(
      id: @trips.length + 1, #id of trip, not driver.
      passenger: find_passenger(passenger_id),
      start_time: Time.now,
      end_time: nil,
      driver: available_drivers[0],
      rating: nil,
      cost: nil
      )
      # **set driver's status to UNAVAILABLE -->> not until driver class, with new add method
      # **Do this in the class files: Add the new trip to the collection of trips for that Driver and Passenger @trips. add_trip(new_trip)
      
      new_trip.passenger.add_trip(new_trip)
      new_trip.driver.add_in_progress_trip(new_trip)
      @trips << new_trip
      
      return new_trip
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