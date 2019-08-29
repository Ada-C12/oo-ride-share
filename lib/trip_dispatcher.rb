require 'csv'
require 'time'
require 'date'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

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
      # passenger = find_passenger(passenger_id)
      @drivers.each do |d|
        status = driver.instance_variable_get(:@status)
        # add below code here? if driver.status == :AVAILABLE and remove ^ line
        if status == :AVAILABLE 
          driver = d
          return driver
        end
      end
      id = @trips[-1].id + 1 #remove this to hash
      start_time = DateTime.now,
      end_time = nil,
      rating = nil, 
      cost = nil
      @trip_data = { # call this new_trip = RideShare::Trip.new ()
        id: id,  #@trips.length + 1
        passenger_id: passenger_id,
        start_time: start_time,
        end_time: end_time, #nil
        rating: rating, #nil 
        cost: cost, #nil
        driver: driver #remove?
      }
      @trip = RideShare::Trip.new(@trip_data)
      # add passenger instance
      #passenger.add_trip(new_trip)
      # driver.change_status(new_trip)
      # @trips << new_trip
      # return new_trip
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
