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
      if @drivers.all? { |d| d.instance_variable_get(:@status) == :UNAVAILABLE } == true
        raise ArgumentError, "There are no available drivers."
      else 
        @drivers.each do |d|
          status = d.instance_variable_get(:@status)
          if status == :AVAILABLE 
            @trip_data = {
              id: @trips[-1].instance_variable_get(:@id) + 1, 
              passenger_id: passenger_id,
              start_time: DateTime.now,
              end_time: nil, 
              rating: nil, 
              cost: nil, 
              driver: d
            }
            trip = RideShare::Trip.new(@trip_data)
            d.instance_variable_get(:@trips) << trip
            status == :UNAVAILABLE
            p = @passengers.find { |p| p.id == passenger_id }
            p.instance_variable_get(:@trips) << trip
            @trips << trip
            return trip
          end
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
  end
end
