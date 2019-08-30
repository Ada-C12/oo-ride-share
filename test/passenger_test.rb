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
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      driver = RideShare::Driver.new(id:1, name: "Emily", vin: "WBS76FYD47DJF7206", status: :AVAILABLE, trips: nil)
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
        driver: driver,
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
  
  describe "net expenditures" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640")
      @driver = RideShare::Driver.new(id:1, name: "Emily", vin: "WBS76FYD47DJF7206", status: :AVAILABLE, trips: nil)
      trip_one = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: Time.parse("2018-12-17 02:39:05 -0800"),
        end_time: Time.parse("2018-12-17 5:09:21 -0800"),
        cost: 20,
        rating: 3,
        driver_id: 1,
        driver: @driver
      }
      
      trip_two = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: Time.parse("2018-12-17 02:39:05 -0800"),
        end_time: Time.parse("2018-12-17 5:09:21 -0800"),
        cost: 20,
        rating: 3,
        driver: @driver,
        driver_id: 1
      }
      trip1 = RideShare::Trip.new(trip_one)
      trip2 = RideShare::Trip.new(trip_two)
      
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
    end
    
    it "returns the total amount of money passenger spend on trips" do
      net_expenditures = @passenger.net_expenditures
      expect(net_expenditures).must_equal 40
      
    end
    it "Raises an error if passenger has no trips" do
      test_passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640")
      expect{test_passenger.net_expenditures}.must_raise ArgumentError
    end
  end
  
  describe "Total time spent" do
    
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640")
      @driver = RideShare::Driver.new(id:1, name: "Emily", vin: "WBS76FYD47DJF7206", status: :AVAILABLE, trips: nil)
      trip_one = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: Time.parse("2018-12-17 02:39:05 -0800"),
        end_time: Time.parse("2018-12-17 5:09:21 -0800"),
        cost: 20,
        rating: 3,
        driver_id: 1,
        driver: @driver
      }
      
      trip_two = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: Time.parse("2018-12-17 02:39:05 -0800"),
        end_time: Time.parse("2018-12-17 5:09:21 -0800"),
        cost: 20,
        rating: 3,
        driver: @driver,
        driver_id: 1
      }
      trip1 = RideShare::Trip.new(trip_one)
      trip2 = RideShare::Trip.new(trip_two)
      
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
    end
    
    it "returns the total amount of time passenger spent on trips" do
      time_spent = @passenger.total_time_spent
      expect(time_spent).must_equal 18032.0
    end
    it "Raises an error if passenger has no trips" do
      test_passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640")
      expect{test_passenger.total_time_spent}.must_raise ArgumentError
    end
  end
end
