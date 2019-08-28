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
        driver_id: 4,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5
        )
      @driver = RideShare::Driver.new(
        id: 2,
        name: "Test Driver 2",
        vin: "12345678912345678",
        )

      @passenger.add_trip(trip)
      @driver.add_trip(trip)
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
    # You add tests for the net_expenditures method
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
        start_time: Time.parse('2015-05-20T6:45:00+00:00'),
        end_time: Time.parse('2015-05-20T7:03:00+00:00'),
        cost: 9,
        rating: 5
        )
      @passenger.add_trip(trip)

      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver_id: 7,
        start_time: Time.parse('2015-05-20T11:14:00+00:00'),
        end_time: Time.parse('2015-05-20T11:20:00+00:00'),
        cost: 6,
        rating: 5
        )
      @passenger.add_trip(trip)
    end

    it "returns net expenditures for all trips that passsenger takes" do
      expect(@passenger.net_expenditures).must_equal 15
    end 

    it "returns the total amount of time for all the trips that passenger takes" do
      expect(@passenger.total_time_spent).must_equal 1440
    end 
  end
end
