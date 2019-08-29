require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'
require_relative 'csv_record'

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
      
      driver = @drivers.find { |driver| driver.status == :AVAIALBLE }
      
      
      in_progress = Trip.new(
        id: ((@trips[-1].id) + 1),
        passenger_id: passenger_id,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: driver
      )
      
      
      in_progress.driver.add_trip(in_progress)
      in_progress.passenger.add_trip(in_progress)
      
      @trips << in_progress
      
      return in_progress
      #create a new instance of Trip
      #automatically assign first driver who is available
      #start time = Time.now
      #end time, cost, rating, will be nil because trip hasn't finished
      #add this trip to driver's trip array
      #change driver status to unavailable (attr_accessor)
      #add this trip to the passenger's trip list
      #add the trip to the trip collection in Trip Dispatcher 
      #will have to write to CSV record
      #return the newly created trip
      
      #driver will need to be edited for in-progress trips
      #passenger will aslo need to be edited, total_time_spent
      
      
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
