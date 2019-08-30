require 'csv'
require 'time'
require 'pry'

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
      chosen_driver = ""
      @drivers.each do |driver|
        if driver.status == :AVAILABLE && driver.trips.length != 0 && driver.trips[-1].end_time != nil
          max_time = 0 
          if driver.trips.length == 0
            chosen_driver = driver
          else
            driver.trips.each do |trip|
              time_apart = Time.now - trip.end_time
              if time_apart > max_time
                max_time = time_apart
                chosen_driver = trip.driver
              end
            end
          end
        else
          return nil
        end
      end
      
      
      passenger = self.find_passenger(passenger_id)
      
      in_progress = Trip.new(
        id: ((@trips[-1].id) + 1),
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: chosen_driver
      )
      
      
      in_progress.driver.add_trip(in_progress)
      in_progress.passenger.add_trip(in_progress)
      
      @trips << in_progress
      
      return in_progress
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
