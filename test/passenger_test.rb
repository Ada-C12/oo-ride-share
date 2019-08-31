require_relative "test_helper"

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
        trips: [],
      )
      @driver = RideShare::Driver.new(
        id: 2,
        name: "Billy Bob",
        vin: "WBS76FYD47DJF7206",
        status: :AVAILABLE,
      )

      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
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
      # You add tests for the net_expenditures method
      it "will return the net expenditures a passenger spent on their trips" do
        @passenger = RideShare::Passenger.new(
          id: 9,
          name: "Merl Glover III",
          phone_number: "1-602-620-2330 x3723",
          trips: [],
        )
      end

      @driver = RideShare::Driver.new(
        id: 2,
        name: "Billy Bob",
        vin: "WBS76FYD47DJF7206",
        status: :AVAILABLE,
      )

      trip = RideShare::Trip.new(
        id: 5,
        passenger: @passenger,
        driver: @driver,
        start_time: Time.parse("2018-12-27 02:39:05 -0800"),
        end_time: Time.parse("2018-12-27 03:38:08 -0800"),
        rating: 5,
        cost: 15,
      )

      trip_two = RideShare::Trip.new(
        id: 6,
        passenger: @passenger,
        driver: @driver,
        start_time: Time.parse("2018-11-17 11:18:35 -0800"),
        end_time: Time.parse("2018-11-17 11:52:29 -0800"),
        rating: 4,
        cost: 28,
      )

      @passenger.add_trip(trip)
      @passenger.add_trip(trip_two)

      expect(@passenger.net_expenditures).must_equal 43
    end
  end

  describe "total_time_spent method" do
    it "will return the total time a passenger spent on their trips" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )

      @driver = RideShare::Driver.new(
        id: 2,
        name: "Billy Bob",
        vin: "WBS76FYD47DJF7206",
        status: :AVAILABLE,
      )

      trip = RideShare::Trip.new(
        id: 5,
        passenger: @passenger,
        driver: @driver,
        start_time: Time.parse("2018-12-27 02:39:05 -0800"),
        end_time: Time.parse("2018-12-27 03:38:08 -0800"),
        rating: 5,
        cost: 15,
      )

      trip_two = RideShare::Trip.new(
        id: 6,
        passenger: @passenger,
        driver: @driver,
        start_time: Time.parse("2018-11-17 11:18:35 -0800"),
        end_time: Time.parse("2018-11-17 11:52:29 -0800"),
        rating: 4,
        cost: 28,
      )

      @passenger.add_trip(trip)
      @passenger.add_trip(trip_two)

      expect(@passenger.total_time_spent).must_equal 5577
    end
  end
end
