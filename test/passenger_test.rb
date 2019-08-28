require_relative 'test_helper'
require 'pry'

describe "Passenger class" do
  
  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end
    
    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end
    
    it "throws an argument error with a bad ID value" do
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
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
        driver_id: 1
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
    it "will correctly calculate total cost of multiple trips" do
      # You add tests for the net_expenditures method
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      
      trip_1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        cost: 10,
        rating: 5,
        driver_id: 1
      )
      
      trip_2 = RideShare::Trip.new(
        id: 7,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        cost: 20,
        rating: 5,
        driver_id: 1
      )
      
      @passenger.add_trip(trip_1)
      @passenger.add_trip(trip_2)
      
      expect(@passenger.net_expenditures).must_equal 30
    end
  end
  
  describe "total_time_spent" do
    it "returns correct amount of time passenger spent during trips" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      
      trip_1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse('2015-05-20T12:14:00+00:00'),
        end_time: Time.parse('2015-05-20T12:14:20+00:00'),
        cost: 10,
        rating: 5,
        driver_id: 1
      )
      
      trip_2 = RideShare::Trip.new(
        id: 7,
        passenger: @passenger,
        start_time: Time.parse('2015-05-21T12:14:00+00:00'),
        end_time: Time.parse('2015-05-21T12:14:20+00:00'),
        cost: 20,
        rating: 5,
        driver_id: 1
      )
      @passenger.add_trip(trip_1)
      @passenger.add_trip(trip_2)
      
      expect(@passenger.total_time_spent).must_equal 40
      
    end
    
    it "raises ArgumentError if passenger has nil trips" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: nil
      )
      #binding.pry
      expect{@passenger.total_time_spent}.must_raise ArgumentError
    end
  end
end
