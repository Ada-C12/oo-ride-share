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
        RideShare::Passenger.new(id: 0, name: "Smithy", phone_number: "353-223-3452")
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
      start_time: Time.parse("2019-01-09 08:30:31 -0800"),
      end_time: Time.parse("2019-01-09 08:48:50 -0800"),
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
    before do
      @passenger = RideShare::Passenger.new(
      id: 9,
      name: "Merl Glover III",
      phone_number: "1-602-620-2330 x3723",
      trips: [])
      
      trip1 = RideShare::Trip.new(
      id: 8,
      passenger: @passenger,
      start_time: Time.parse("2019-01-09 08:30:31 -0800"),
      end_time: Time.parse("2019-01-09 08:48:50 -0800"),
      cost: 7,
      rating: 5)
      
      trip2 = RideShare::Trip.new(
      id: 10,
      passenger: @passenger,
      start_time: Time.parse("2019-01-17 04:33:18 -0800"),
      end_time: Time.parse("2019-01-17 05:15:59 -0800"),
      cost: 20,
      rating: 2)
      
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
    end
    
    it "returns total amount of money passenger spent on their trips" do
      expect (@passenger.net_expenditures).must_equal 27
    end
    
    it "returns an number" do
      expect (@passenger.net_expenditures).must_be_kind_of Numeric
    end
    
    it "returns 0 if passenger doesn't have any trip" do
      no_trip_passenger = RideShare::Passenger.new(
      id: 9,
      name: "Merl Glover III",
      phone_number: "1-602-620-2330 x3723",
      trips: [])
      expect (no_trip_passenger.net_expenditures).must_equal 0
    end
  end

  describe "total_time_spent" do
    before do
      @passenger = RideShare::Passenger.new(
      id: 9,
      name: "Merl Glover III",
      phone_number: "1-602-620-2330 x3723",
      trips: [])
      
      trip1 = RideShare::Trip.new(
      id: 8,
      passenger: @passenger,
      start_time: Time.parse("2019-01-09 08:30:31 -0800"),
      end_time: Time.parse("2019-01-09 08:48:50 -0800"),
      cost: 7,
      rating: 5)
      
      trip2 = RideShare::Trip.new(
      id: 10,
      passenger: @passenger,
      start_time: Time.parse("2019-01-17 04:33:18 -0800"),
      end_time: Time.parse("2019-01-17 05:15:59 -0800"),
      cost: 20,
      rating: 2)
      
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)

      TOTAL_DURATION = trip1.duration + trip2.duration
    end

    it "returns a number" do
      expect (@passenger.total_time_spent).must_be_kind_of Numeric
    end

    it "returns the total amount of time in seconds passenger has spent on their trips" do
      expect (@passenger.total_time_spent).must_equal TOTAL_DURATION
    end

    it "returns 0 if passenger doesn't have any trip" do
      no_trip_passenger = RideShare::Passenger.new(
      id: 9,
      name: "Merl Glover III",
      phone_number: "1-602-620-2330 x3723",
      trips: [])
      expect (no_trip_passenger.total_time_spent).must_equal 0
    end
  end
end
