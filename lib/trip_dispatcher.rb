require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'    

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips
    
    def initialize(directory: './support')
      # @passengers = [PassengerInstance1, PassengerInstance2, etc]
      @passengers = Passenger.load_all(directory: directory)
      # @drivers = [DriverInstance1, DriverInstance2, etc]    
      @drivers = Driver.load_all(directory: directory)      
      # @trips = [TripInstance1, TripInstance2, etc]
      @trips = Trip.load_all(directory: directory)
      
      # add each TripInstance from @trips to corresponding DriverInstance's or PassengerInstance's @trips array
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
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
      #{trips.count} trips, \
      #{drivers.count} drivers, \
      #{passengers.count} passengers>"
    end
    
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
      
      # Driver selection priority: driver_with_zero_trips > driver_driest_spell 
      # Req'ts: 1. must be :AVAILABLE, = 2. Must not have any ongoing trips (end_time = nil) 
      
      driver_with_zero_trips = nil
      driver_driest_spell = nil
      longest_dry_spell = 0
      now = Time.now
      
      # determine each driver's place per priority scale
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          if driver.trips == []
            driver_with_zero_trips = driver
            break
          else 
            # evaluate dry spell, assuming drivers.trips in random chrono order
            most_recent_trip = driver.trips.min_by do |trip| 
              now - trip.end_time
            end
            dry_spell = now - most_recent_trip.end_time
            
            if dry_spell > longest_dry_spell
              longest_dry_spell = dry_spell
              driver_driest_spell = driver
            end
          end
        end
      end
      
      # choose the driver based on priority
      if driver_with_zero_trips
        chosen_driver = driver_with_zero_trips
      elsif driver_driest_spell
        chosen_driver = driver_driest_spell
      else
        # no one is :AVAILABLE, can't make new Trip instance anyway
        return nil
      end
      
      # update driver status
      chosen_driver.switch_status
      
      # Make new Trip instance, all arguments are acceptable
      new_trip = RideShare::Trip.new(id:new_trip_id, passenger: passenger, passenger_id: passenger_id, start_time: Time.now, end_time: nil, cost: nil, rating: nil, driver_id: chosen_driver.id, driver: chosen_driver)
      
      # Add this Trip to 1. driver's @trips, 2. passenger's @trips, 3. TripDispatcher instance's @Trips
      chosen_driver.add_trip(new_trip)
      passenger.add_trip(new_trip)
      @trips << new_trip 
      
      return new_trip
    end
    
    
    
    private
    
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
