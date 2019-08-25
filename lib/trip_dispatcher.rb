require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips
    
    def initialize(directory: './support')
      # @passengers = [PassengerInstance1, PassengerInstance2, etc]
      @passengers = Passenger.load_all(directory: directory)
      # @trips = [TripInstance1, TripInstance2, etc]
      @trips = Trip.load_all(directory: directory)
      
      # add each TripInstance from @trips to corresponding PassengerInstance's @trips array
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
    
    private
    
    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger)
      end
      
      return trips
    end
  end
end
