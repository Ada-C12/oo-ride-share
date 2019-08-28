require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
      directory: TEST_DATA_DIRECTORY
    )
  end
  
  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = build_test_dispatcher
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end
    
    it "establishes the base data structures when instantiated" do
      dispatcher = build_test_dispatcher
      [:trips, :passengers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end
      
      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      # expect(dispatcher.drivers).must_be_kind_of Array
    end
    
    it "loads the development data by default" do
      # Count lines in the file, subtract 1 for headers
      trip_count = %x{wc -l 'support/trips.csv'}.split(' ').first.to_i - 1
      
      dispatcher = RideShare::TripDispatcher.new
      
      expect(dispatcher.trips.length).must_equal trip_count
    end
  end
  
  describe "passengers" do
    describe "find_passenger method" do
      before do
        @dispatcher = build_test_dispatcher
      end
      
      it "throws an argument error for a bad ID" do
        expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
      end
      
      it "finds a passenger instance" do
        passenger = @dispatcher.find_passenger(2)
        expect(passenger).must_be_kind_of RideShare::Passenger
      end
    end
    
    describe "Passenger & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end
      
      it "accurately loads passenger information into passengers array" do
        first_passenger = @dispatcher.passengers.first
        last_passenger = @dispatcher.passengers.last
        
        expect(first_passenger.name).must_equal "Passenger 1"
        expect(first_passenger.id).must_equal 1
        expect(last_passenger.name).must_equal "Passenger 8"
        expect(last_passenger.id).must_equal 8
      end
      
      it "connects trips and passengers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.passenger).wont_be_nil
          expect(trip.passenger.id).must_equal trip.passenger_id
          expect(trip.passenger.trips).must_include trip
        end
      end
    end
  end
  
  # TODO: un-skip for Wave 2
  describe "drivers" do
    describe "find_driver method" do
      before do
        @dispatcher = build_test_dispatcher
      end
      
      it "throws an argument error for a bad ID" do
        expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
      end
      
      it "finds a driver instance" do
        driver = @dispatcher.find_driver(2)
        expect(driver).must_be_kind_of RideShare::Driver
      end
    end
    
    describe "Driver & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end
      
      it "accurately loads driver information into drivers array" do
        first_driver = @dispatcher.drivers.first
        last_driver = @dispatcher.drivers.last
        
        expect(first_driver.name).must_equal "Driver 1 (unavailable)"
        expect(first_driver.id).must_equal 1
        expect(first_driver.status).must_equal :UNAVAILABLE
        expect(last_driver.name).must_equal "Driver 3 (no trips)"
        expect(last_driver.id).must_equal 3
        expect(last_driver.status).must_equal :AVAILABLE
      end
      
      it "connects trips and drivers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.driver).wont_be_nil
          expect(trip.driver.id).must_equal trip.driver_id
          expect(trip.driver.trips).must_include trip
        end
      end
    end
  end
  
  describe "request trip method" do
    before do
      @dispatcher = build_test_dispatcher
    end
    
    it "creates a new trip" do
      # must return an instance of trip
      
      new_trip = @dispatcher.request_trip(1)
      
      expect(new_trip).must_be_instance_of Trip
      
    end
    
    it "assigns a driver to the new trip" do
      # driver must be instance of Driver

      new_trip = @dispatcher.request_trip(1)
      new_driver = new_trip.driver
      expect(new_driver).must_be_instance_of Driver

    end 
    
    it "it assigns the correct driver" do
      # we tell it which one to expect from the test data
      new_trip = @dispatcher.request_trip(1)
      new_driver_name = new_trip.driver.name

      expect(new_driver_name).must_equal "Driver 2"
    end
    
    it "assigns a driver whose status is available" do
      # driver status must be available
      new_trip = @dispatcher.request_trip(1)
      new_driver_status = new_trip.driver.status

      expect(new_driver_status).must_equal :AVAILABLE
    end
    
    it "raises an ArgumentError if given an invalid passenger ID" do
      expect{@dispatcher.request_trip(26)}.must_raise ArgumentError
    end
    
    it "makes start time equal to current time" do
      # must be instance of time
      # must be current time ?

      new_trip = @dispatcher.request_trip(1)
      new_trip_time = new_trip.start_time

      expect(new_trip_time).must_be_instance_of Time
      expect(new_trip_time).must_equal Time.now
    end
    
    it "makes end date, cost, and rating equal nil" do
      new_trip = @dispatcher.request_trip(1)
      new_trip_end_time = new_trip.end_time
      new_trip_cost = new_trip.cost
      new_trip_rating = new_trip.rating

      expect(new_trip_end_time).must_be_nil
      expect(new_trip_cost).must_be_nil
      expect(new_trip_rating).must_be_nil
    end
    
    it "must add new trip to the passenger's list of trips" do
      new_trip = @dispatcher.request_trip(1)
      passenger_trips = @passenger.trips

      expect(passenger_trips).must_include new_trip
    end
    
    it "must add new trip to the driver's list of trips" do
      new_trip = @dispatcher.request_trip(1)
      driver_trips = @driver.trips

      expect(driver_trips).must_include new_trip
    end
    
    it "must add new trip to the trip dispatcher's list of trips" do
      new_trip = @dispatcher.request_trip(1)
      dispatcher_trips = self.trips

      expect(dispatcher_trips).must_include new_trip
    end
    
    it "raises an ArgumentError if there are no drivers available" do
      @drivers[1].status = :UNAVAILABLE
      @drivers[2].status = :UNAVAILABLE
      
      expect{@dispatcher.request_trip(1)}.must_raise ArgumentError
    end
    
  end
end
