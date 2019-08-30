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
        driver_id: 3
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
  
  describe "totaling methods" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      @trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2018-05-25 11:52:40 -0700"),
        end_time: Time.parse("2018-05-25 12:25:00 -0700"),
        rating: 5,
        cost: 20,
        driver_id: 3
      )
      @trip_two = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2018-08-05 08:58:00 -0700"),
        end_time: Time.parse("2018-08-05 09:30:00 -0700"),
        rating: 3,
        cost: 10,
        driver_id: 3
      ) 
      @trip_three = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2018-08-05 08:58:00 -0700"),
        end_time: nil,
        rating: nil,
        cost: nil,
        driver_id: 3
      )   
    end
    
    describe "net expenditure method" do
      
      it "returns passenger's total spending" do
        @passenger.add_trip(@trip)
        @passenger.add_trip(@trip_two)
        
        total = @passenger.net_expenditures
        expect(total).must_equal 30
      end
      
      it "returns 0 if passenger took no trips" do
        total = @passenger.net_expenditures
        expect(total).must_equal 0
      end
      
      it "ignores in-progress trips" do
        @passenger.add_trip(@trip)
        @passenger.add_trip(@trip_two)
        @passenger.add_trip(@trip_three)
        
        total = @passenger.net_expenditures
        expect(total).must_equal 30
      end
    end
    
    describe "total time spent method" do
      it "returns passenger's total time spent" do
        @passenger.add_trip(@trip)
        @passenger.add_trip(@trip_two)
        
        total = @passenger.total_time_spent
        expect(total).must_equal 3860
      end
      
      it "returns 0 if passenger took no trips" do
        total = @passenger.total_time_spent
        expect(total).must_equal 0
      end
      
      it "ignores in-progress trips" do
        @passenger.add_trip(@trip)
        @passenger.add_trip(@trip_two)
        @passenger.add_trip(@trip_three)
        
        total = @passenger.total_time_spent
        expect(total).must_equal 3860
      end
      
    end
  end
end
