require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'


module RideShare
  class TripDispatcher
    attr_reader :passengers, :drivers, :trips

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
      #find driver by available 
      # automatically assign driver to this new instance of trip

      all_available = @drivers.find_all { |driver| driver.status == :AVAILABLE }
      driver = all_available.first 

      start_time = Time.now

      #an array of trips - find the last one and add one every time
      #id to equal the length of the trips array +1
      trip = RideShare::Trip.new(
        id: @trips.length + 1,
        driver: driver,
        passenger: find_passenger(passenger_id),
        start_time: start_time,
        end_time: nil,
        cost: nil,
        rating: nil
      )
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
        #trip.connect(driver)
      end
      return trips
    end

  end
end
