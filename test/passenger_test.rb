require_relative "test_helper"

xdescribe "Passenger class" do
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
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
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
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      trip1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
        rating: 5,
        cost: 18,
      )
      trip2 = RideShare::Trip.new(
        id: 500,
        passenger: @passenger,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
        rating: 5,
        cost: 10,
      )
      trip3 = RideShare::Trip.new(
        id: 7,
        passenger: @passenger,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
        rating: 5,
        cost: 12,
      )
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      @passenger.add_trip(trip3)
    end
    
    it "Sums all costs from a single instance of passenger" do
      total = @passenger.net_expenditures
      
      expect(total).must_equal 40
    end
    
    it "returns a value in the form of an integer." do
      total = @passenger.net_expenditures
      expect(total).must_be_instance_of Integer
    end
  end
  
  describe "total_time_spent" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      trip1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: ("2018-12-31 14:35:22 -0800"),
        end_time: ("2018-12-31 15:22:40 -0800"),
        rating: 5,
        cost: 18,
      )
      trip2 = RideShare::Trip.new(
        id: 500,
        passenger: @passenger,
        start_time: ("2018-12-31 02:35:22 -0800"),
        end_time: ("2018-12-31 04:35:22 -0800"),
        rating: 5,
        cost: 10,
      )
      trip3 = RideShare::Trip.new(
        id: 7,
        passenger: @passenger,
        start_time: ("2018-12-31 20:35:22 -0800"),
        end_time: ("2018-12-31 21:35:22 -0800"),
        rating: 5,
        cost: 12,
      )
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      @passenger.add_trip(trip3)
    end
    
    it "returns total amount of time that passenger has spent on their trips" do
      total_time = @passenger.total_time_spent
      expect(total_time).must_equal 13638
    end
    
    it "must return an instance of an integer" do
      total_time = @passenger.total_time_spent
      expect(total_time).must_be_instance_of Integer
    end
  end
end
