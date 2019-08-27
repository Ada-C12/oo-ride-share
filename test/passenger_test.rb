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
      @driver = RideShare::Driver.new(
        id: 1,
        name: "Paul Klee",
        vin: "WBS76FYD47DJF7206",
        status: :AVAILABLE
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
        rating: 5,
        driver: @driver
      )
      
      @passenger.add_trip(trip)
      # @driver.add_trip(trip)
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
  
  describe "net_expenditures/total_time_spent" do
    before do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      @driver = RideShare::Driver.new(
        id: 1,
        name: "Paul Klee",
        vin: "WBS76FYD47DJF7206",
        status: :AVAILABLE
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: start_time,
        end_time: start_time + 25 * 60, # 25 minutes
        cost: 3,
        rating: 5,
        driver: @driver
      )
      
      trip2 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: start_time,
        end_time: start_time + 35 * 60, # 35 minutes
        cost: 5,
        rating: 5,
        driver: @driver
      )
      
      @passenger.add_trip(trip)
      @passenger.add_trip(trip2)
    end
    
    it "returns the total amount of time" do
      expect(@passenger.total_time_spent).must_equal 3600
    end
    
    it "returns the total amount of money spent on trips" do
      expect(@passenger.net_expenditures).must_equal 8
    end
  end
  
  describe "net_expenditures/total_time_spent - no trips" do
    before do 
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
    end
    
    it "returns the total amount of time" do
      expect(@passenger.total_time_spent).must_equal 0
    end
    
    it "returns the total amount of money spent on trips" do
      expect(@passenger.net_expenditures).must_equal 0
    end
  end
end
