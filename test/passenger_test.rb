require_relative 'test_helper'

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
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
        rating: 5,
        driver_id: 123
      )
      
      @passenger.add_trip(trip)
    end
    
    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip, "item is in #{trip}"
      end
    end
    
    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end
  
  describe "net_expenditures" do
    it "returns the correct net expenditure" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip_1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
        cost: 5.50,
        rating: 5,
        driver_id: 123
      )
      
      trip_2 = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
        cost: 2.25,
        rating: 5,
        driver_id: 123
      )
      
      @passenger.add_trip(trip_1)
      @passenger.add_trip(trip_2)
      
      expect(@passenger.net_expenditures).must_equal 7.75
    end 
  end
  
  describe "total_time_spent" do
    it "returns the correct total time spent" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip_1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2016-08-08 00:00:00"),
        end_time: Time.parse("2016-08-08 00:01:26"),
        cost: 5.50,
        rating: 5,
        driver_id: 123
      )
      
      trip_2 = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: Time.parse("2016-08-09 00:00:00"),
        end_time: Time.parse("2016-08-09 00:00:34"),
        cost: 2.25,
        rating: 5,
        driver_id: 123
      )
      
      @passenger.add_trip(trip_1)
      @passenger.add_trip(trip_2)
      
      expect(@passenger.total_time_spent).must_equal 120
    end
  end
end
