require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'     ###JULIA### added this for Wave2

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips
    
    def initialize(directory: './support')
      # @passengers = [PassengerInstance1, PassengerInstance2, etc]
      @passengers = Passenger.load_all(directory: directory)
      # @trips = [TripInstance1, TripInstance2, etc]
      @trips = Trip.load_all(directory: directory)
      # @drivers = [DriverInstance1, DriverInstance2, etc]    
      @drivers = Driver.load_all(directory: directory)      ###JULIA### added this for Wave2
      
      # add each TripInstance from @trips to corresponding DriverInstance's or PassengerInstance's @trips array
      connect_trips
    end
    
    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end
    
    def find_driver(id)       ###JULIA### added for Wave2: Loading Drivers
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
    
    
    
    
    private
    
    # def connect_trips     ###CAROLINE### ORIGINAL VERSION, leave here just in case
    #   @trips.each do |trip|
    #     passenger = find_passenger(trip.passenger_id)
    #     trip.connect(passenger)
    #   end
    # end
    
    ###JULIA### CHANGED BLOCK for Wave 2:Loading Drivers
    def connect_trips
      # each TripInstance knows who the driver and passengers are, but we need to log this ride in each person's @trips too
      # add each TripInstance from @trips to corresponding DriverInstance's or PassengerInstance's @trips array
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)    
        
        # update the @trips for the Driver and Passenger instances
        trip.connect(driver, passenger)                    
      end
      
      return trips
    end
  end
end
