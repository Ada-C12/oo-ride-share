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
      # @drivers = [DriverInstance1, DriverInstance2, etc]    
      @drivers = Driver.load_all(directory: directory)      ###JULIA### added this for Wave2
      # @trips = [TripInstance1, TripInstance2, etc]
      @trips = Trip.load_all(directory: directory)
      
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
    
    ###JULIA### added for wave 3
    def request_trip(passenger_id)
      # Returns a new Trip instance
      
      # Before making new Trip instance, will need the arguments for it
      passenger = find_passenger(passenger_id)
      start_time = Time.now
      end_time = nil
      cost = nil
      rating = nil
      latest_trip_id = @trips[-1].id
      new_trip_id = latest_trip_id + 1
      
      # Driver seletion: choose 1st driver whose statu is :AVAILABLE, then flip their status
      chosen_driver = nil
      stop_driver_search = false
      while stop_driver_search == false
        @drivers.each do |driver|
          if driver.status == :AVAILABLE
            chosen_driver = driver
            chosen_driver.switch_status
            stop_driver_search = true
            break
          end
        end
        stop_driver_search = true
      end
      
      # If no drivers available, can't make new Trip, return nil
      if chosen_driver == nil
        return nil
      end
      
      # Make new Trip instance, all arguments are acceptable
      new_trip = RideShare::Trip.new(id:new_trip_id, passenger: passenger, passenger_id: passenger_id, start_time: start_time, end_time: end_time, cost: nil, rating: nil, driver_id: chosen_driver.id, driver: chosen_driver)

      # Add this Trip to 1. driver's @trips, 2. passenger's @trips, 3. TripDispatcher instance's @Trips
      chosen_driver.add_trip(new_trip)
      passenger.add_trip(new_trip)
      @trips << new_trip 
      
      return new_trip
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
