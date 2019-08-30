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
  
  describe "testing net_expenditures" do
    before do
      @bart = RideShare::Passenger.new(
          id: 1,
          name: "Bart Simpson",
          phone_number: "1-800-123-1234",
          trips: []
        )
      @ongoing_trip = RideShare::Trip.new(
        id: 99, 
        passenger_id: 1,
        start_time: Time.now, 
        end_time: nil, 
        cost: nil, 
        rating: nil, 
        driver: @bart
        )
      @trip1 = RideShare::Trip.new(
        id: 11,
        passenger: @bart,
        start_time: Time.now,
        end_time: Time.now + 3000,
        cost: 5.00,
        rating: 5,
        driver_id: 100
      )
      @trip2 = RideShare::Trip.new(
        id: 12,
        passenger: @bart,
        start_time: Time.now,
        end_time: Time.now + 6000,
        cost: 15.00,
        rating: 5,
        driver_id: 100
      )
    end    

    it "if no trips, net_expenditures should return 0" do
      expect(@bart.net_expenditures).must_equal 0.0
    end

    it "for a single ongoing trip, net_expenditures should return 0" do
      @bart.add_trip(@ongoing_trip)
      expect(@bart.net_expenditures).must_equal 0.0
    end
    
    it "check if net_expenditures return correct Float value" do
      @bart.add_trip(@trip1)
      @bart.add_trip(@trip2)
      assert(@bart.net_expenditures == 20)
      assert(@bart.net_expenditures.class == Float)
    end
  end
  
  describe "testing total_time_spent" do
    before do
      @bart = RideShare::Passenger.new(
        id: 1,
        name: "Bart Simpson",
        phone_number: "1-800-123-1234",
        trips: []
      )
      @ongoing_trip = RideShare::Trip.new(
        id: 99, 
        passenger: @bart, 
        start_time: Time.now, 
        end_time: nil, 
        cost: nil, 
        rating: nil, 
        driver_id: 88
      )
      @trip1 = RideShare::Trip.new(
        id: 98, 
        passenger: @bart, 
        start_time: Time.now, 
        end_time: Time.now + 1000, 
        cost: nil, 
        rating: nil, 
        driver_id: 88
      )
      @trip2 = RideShare::Trip.new(
        id: 97, 
        passenger: @bart,
        start_time: Time.now, 
        end_time: Time.now + 2000, 
        cost: nil, 
        rating: nil, 
        driver_id: 88
      )
    end
    
    it "if no trips, check total_time_spent returns 0" do
      expect(@bart.total_time_spent).must_equal 0
    end

    it "for a single ongoing trip, check total_time_spent returns 0" do      
      @bart.add_trip(@ongoing_trip)
      expect(@bart.total_time_spent).must_equal 0
    end

    it "for a single ongoing trip among finished trips, check total_time_spent returns correct number and ignores the ongoing trip" do
      # I decided to count time spent as 0 (instead of nil) until trip officially finishes
      [@ongoing_trip, @trip1, @trip2].each do |trip|
        @bart.add_trip(trip)
      end
      expect(@bart.total_time_spent).must_equal 3000
    end

    it "check if total_time_spent returns correct number of seconds" do
      @bart.add_trip(@trip1)
      @bart.add_trip(@trip2)
      expect(@bart.total_time_spent).must_equal 3000
    end
  end
end
