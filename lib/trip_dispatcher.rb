require 'csv'
require 'time'
require 'pry'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

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
      available_drivers = @drivers.select {|driver| driver.status == :AVAILABLE } #&& driver.trips.include?{|trip| trip.end_time == nil} == false}
      available_drivers.reject! {|driver| driver.trips.find {|trip| trip.end_time == nil}}
      
      #puts "AVAILABLE DRIVERS #{available_drivers}"
      raise ArgumentError, "No drivers currently available" if available_drivers == [] || available_drivers == nil
      
      requested_driver = available_drivers.find {|driver| driver.trips.length == 0}
      
      if requested_driver == nil
        requested_driver = available_drivers.min_by {|driver| driver.trips.max_by {|ride| ride.end_time}.end_time}
      end
      
      start_time = Time::now
      # NOTE: We assume new trip ID is next consecutive trip ID
      id = @trips.length + 1
      
      current_trip = Trip.new(id: id, passenger: find_passenger(passenger_id), passenger_id: passenger_id, start_time: start_time, end_time: nil, rating: nil, driver: requested_driver)
      
      requested_driver.add_trip(current_trip)
      requested_driver.change_status_to_unavailable
      
      current_trip.passenger.add_trip(current_trip)
      
      @trips << current_trip
      
      return current_trip
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


# available_drivers.first.trips.max_by {|ride| ride.end_time}
# => #<RideShare::Trip:0x3ff09e0c2fdc ID=254 PassengerID=26>

# available_drivers.max_by {|driver| driver.name}
# Does return a driver object

# available_drivers.min_by {|driver| driver.trips.max_by {|ride| ride.end_time}.end_time}
#  #<RideShare::Driver:0x00007fe13d0c1428
#  @id=28,
#  @name="Da Vinci",
#  @status=:AVAILABLE,
#  @trips=
#   [#<RideShare::Trip:0x3ff09e8704f0 ID=44 PassengerID=3>,
#    #<RideShare::Trip:0x3ff09dd7b93c ID=159 PassengerID=31>,
#    #<RideShare::Trip:0x3ff09e16654c ID=171 PassengerID=29>,
#    #<RideShare::Trip:0x3ff09e1071a0 ID=202 PassengerID=121>,
#    #<RideShare::Trip:0x3ff09e874d34 ID=240 PassengerID=71>,
#    #<RideShare::Trip:0x3ff09e0c77f8 ID=245 PassengerID=132>,
#    #<RideShare::Trip:0x3ff09e0bfd00 ID=261 PassengerID=41>,
#    #<RideShare::Trip:0x3ff09dd1c9c8 ID=310 PassengerID=51>,
#    #<RideShare::Trip:0x3ff09dd00cdc ID=325 PassengerID=42>,
#    #<RideShare::Trip:0x3ff09dcd5fa0 ID=371 PassengerID=121>,
#    #<RideShare::Trip:0x3ff09e1d9bdc ID=387 PassengerID=42>,
#    #<RideShare::Trip:0x3ff09e1c14ec ID=395 PassengerID=1>,
#    #<RideShare::Trip:0x3ff09e192714 ID=411 PassengerID=80>,
#    #<RideShare::Trip:0x3ff09dd7a1a4 ID=429 PassengerID=94>,
#    #<RideShare::Trip:0x3ff09e11e97c ID=461 PassengerID=66>,
#    #<RideShare::Trip:0x3ff09e11bc40 ID=462 PassengerID=88>,
#    #<RideShare::Trip:0x3ff09e114c4c ID=466 PassengerID=140>,
#    #<RideShare::Trip:0x3ff09e0cb7a4 ID=495 PassengerID=65>,
#    #<RideShare::Trip:0x3ff09e0ca2c8 ID=497 PassengerID=72>,
#    #<RideShare::Trip:0x3ff09e874028 ID=506 PassengerID=119>,
#    #<RideShare::Trip:0x3ff09dd3d3f8 ID=550 PassengerID=30>,
#    #<RideShare::Trip:0x3ff09dd3c930 ID=551 PassengerID=48>],
#  @vin="1F1UPW5C7UHBH1CP4">
