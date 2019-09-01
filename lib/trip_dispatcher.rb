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
    
    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
      #{trips.count} trips, \
      #{drivers.count} drivers, \
      #{passengers.count} passengers>"
    end
    
    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end
    
    def request_trip(passenger_id)
      # raise error if there are no drivers available
      # drivers.each do |driver| 
      #   raise ArgumentError.new("There are no drivers available")
      
      # find first driver who is available and assign them to new trip
      assigned_driver = @drivers.find { |driver| driver.status == :AVAILABLE}
      
      # define variables needed for trip instantiation
      # to generate trip id, take the last trip id in trips.csv and add 1
      id = (@trips.length) + 1
      start_time = Time.now
      end_time = nil
      rating = nil
      
      # instantiate the new trip
      new_trip = Trip.new(
        id: id, 
        passenger_id: passenger_id, 
        start_time: start_time, 
        end_time: end_time, 
        rating: rating, 
        driver_id: assigned_driver.id, 
        driver: assigned_driver 
      )
      
      # use helper method in driver.rb to update driver's trips and status
      assigned_driver.driver_helper(new_trip)
      
      # use the passenger id to look up passenger
      passenger = @passengers.find { |passenger| passenger.id == id }
      
      # add the new trip to the passenger's collection of trips
      
      # add the new trip to collection of all trips
      @trips << new_trip
      
      # return the newly created trip
      return new_trip
    end
    
  end
  
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
