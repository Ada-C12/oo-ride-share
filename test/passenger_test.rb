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
        #added this to aid in all other tests
        passenger: @passenger,
        # Julia's note: not sure if syntax below is correct
        start_time: Time.parse('2016-08-08'),
        end_time: Time.parse('2016-08-09'),
        rating: 5,
        driver_id: 8
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
    
    it "calculates passenger net expenditures" do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
      trip1 = RideShare::Trip.new( id: 8, driver_id: 4, passenger_id: 3, start_time: Time.parse("2016-08-08"), end_time: Time.parse("2016-08-09"), cost: 2, rating: 1)
      trip2 = RideShare::Trip.new( id: 8, driver_id: 9, passenger_id: 5, start_time: Time.parse("2016-08-08"), end_time: Time.parse("2016-08-09"), cost: 4, rating: 1)
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      expect(@passenger.net_expenditures).must_equal 6
    end
    
    it "returns 0 if net_expenditures is called on a passenger with no trips" do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")  
      expect(@passenger.net_expenditures).must_equal 0
    end
        
    it "calculates total time spent per passenger" do
      trip1 = RideShare::Trip.new( id: 8, driver_id: 4, passenger_id: 3, start_time: Time.parse("2016-08-08"), end_time: Time.parse("2016-08-09"), cost: 2, rating: 1)
      trip2 = RideShare::Trip.new( id: 8, driver_id: 9, passenger_id: 3, start_time: Time.parse("2016-08-08"), end_time: Time.parse("2016-08-09"), cost: 4, rating: 1)
      expect(@passenger.total_time_spent).must_equal 86400
    end
    
    it "returns 0 if total_time_spent is called on a passenger with no trips" do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")  
      expect(@passenger.total_time_spent).must_equal 0
    end
    
  end
end
