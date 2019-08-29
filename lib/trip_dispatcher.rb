require 'csv'
require 'time'
# require 'pry'

require_relative 'passenger'
require_relative 'trip'

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
    
    def request_trip(passenger_id)
      request_driver_id = nil
      
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          request_driver_id = driver.id
          break
        end
      end
      
      start_time = Time.now
      end_time =  nil 
      trip_id = @trips.length + 1
      
      in_progress_trip = Trip.new(id: trip_id, rating: nil, passenger_id: passenger_id, start_time: start_time, end_time: end_time, driver_id: request_driver_id)
      driver_object = find_driver(request_driver_id)
      passenger_object = find_passenger(passenger_id)
      #in_progress_trip.connect(find_passenger(passenger_id), driver_object)
      driver_object.update_driver(in_progress_trip)
      passenger_object.update_passenger(in_progress_trip)
      
      @trips.push(in_progress_trip)
      #in_progress_trip.driver_id.connect_trips
      return in_progress_trip
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
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver) 
      end
      return trips
    end
  end
end
