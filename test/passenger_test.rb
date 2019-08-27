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
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
        driver_id: 100
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
  
  ###JULIA### ADDED BLOCK for wave 1.2.1  
  describe "testing net_expenditures" do
    # Passenger objects MUST be instantiated separately b/c IT blocks are assessed in RANDOM order w/in each DESCRIBE block
    
    it "if no trips, check net_expenditures should return 0" do
      bart = RideShare::Passenger.new(
        id: 1,
        name: "Bart Simpson",
        phone_number: "1-800-123-1234",
        trips: []
      )
      bart_total_money_spent = bart.net_expenditures
      expect(bart_total_money_spent).must_equal 0.0
    end
    
    it "check if net_expenditures return correct Float value" do
      bart = RideShare::Passenger.new(
        id: 1,
        name: "Bart Simpson",
        phone_number: "1-800-123-1234",
        trips: []
      )
      trip1 = RideShare::Trip.new(
        id: 11,
        passenger: bart,
        start_time: Time.now,
        end_time: Time.now + 3000,
        cost: 5.00,
        rating: 5,
        driver_id: 100
      )
      trip2 = RideShare::Trip.new(
        id: 12,
        passenger: bart,
        start_time: Time.now,
        end_time: Time.now + 6000,
        cost: 15.00,
        rating: 5,
        driver_id: 100
      )
      bart.add_trip(trip1)
      bart.add_trip(trip2)
      bart_total_money_spent = bart.net_expenditures
      assert(bart_total_money_spent == 20)
      assert(bart_total_money_spent.class == Float)
    end
  end
  
  ###JULIA### ADDED BLOCK for wave 1.2.2
  describe "testing total_time_spent" do
    # Passenger objects MUST be instantiated separately b/c IT blocks are assessed in RANDOM order w/in each DESCRIBE block
    
    it "if no trips, check total_time_spent returns 0" do
      bart = RideShare::Passenger.new(
        id: 1,
        name: "Bart Simpson",
        phone_number: "1-800-123-1234",
        trips: []
      )
      expect(bart.total_time_spent).must_equal 0
    end
    
    it "check if total_time_spent returns correct number of seconds" do
      bart = RideShare::Passenger.new(
        id: 1,
        name: "Bart Simpson",
        phone_number: "1-800-123-1234",
        trips: []
      )
      trip1 = RideShare::Trip.new(
        id: 11,
        passenger: bart,
        start_time: Time.now,
        end_time: Time.now + 3000,
        cost: 5.00,
        rating: 5,
        driver_id: 100
      )
      trip2 = RideShare::Trip.new(
        id: 12,
        passenger: bart,
        start_time: Time.now,
        end_time: Time.now + 6000,
        cost: 15.00,
        rating: 5,
        driver_id: 100
      )
      bart.add_trip(trip1)
      bart.add_trip(trip2)
      expect(bart.total_time_spent).must_equal 9000
    end
    
  end
end
