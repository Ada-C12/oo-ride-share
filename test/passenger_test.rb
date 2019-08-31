require_relative 'test_helper'
require 'time'

describe "Passenger class" do
  
  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end
    
    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end
    
    it "throws an ArgumentError with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end
    
    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end
      
      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end
  
  
  describe "trips property" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver_id: 9,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
        rating: 5
      )
      
      @passenger.add_trip(trip)
    end
    
    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end
    
    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
    
  end
  
  describe "net_expenditures" do
    it "verifies the total expenditure by passenger" do
      
      # populates passenger and trip instances
      all_trips = RideShare::Trip.load_all(directory: './support')
      
      # pulls the cost of all trips taken by passenger 3
      cost_by_passenger = 0
      trips_by_passenger = []
      
      all_trips.each do |trip|
        if trip.cost != nil && trip.passenger_id == 3
          cost_by_passenger += trip.cost
          trips_by_passenger.push(trip)
        end
      end
      
      passenger = RideShare::Passenger.new(id: 3, name: "Melvin Gerlach DDS", phone_number: "562-716-1794", trips: trips_by_passenger)
      
      expect(passenger.net_expenditures).must_equal cost_by_passenger
      
    end
  end
  
  describe "total_time_spent" do
    it "verifies the total time spent by passenger" do
      
      # populates passenger and trip instances
      all_trips = RideShare::Trip.load_all(directory: './support')
      
      # pulls the cost of all trips taken by passenger 3
      total_time_by_passenger = 0
      trips_by_passenger = []
      
      all_trips.each do |trip|
        if trip.passenger_id == 3
          total_time_by_passenger += trip.duration
          trips_by_passenger.push(trip)
        end
      end
      
      passenger = RideShare::Passenger.new(id: 3, name: "Melvin Gerlach DDS", phone_number: "562-716-1794", trips: trips_by_passenger)
      
      expect(passenger.total_time_spent).must_equal total_time_by_passenger
      
    end
    
  end
  
end