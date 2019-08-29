require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'
UNAVAILABLE_TEST_DATA = 'test/all_unavailable_test_data'
NIL_END_TIME_TEST_DATA = 'test/nil_end_time_test_data'

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
      [:trips, :passengers, :drivers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end
      
      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      expect(dispatcher.drivers).must_be_kind_of Array
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
    
    describe "Find available Driver" do
      before do
        @dispatcher = build_test_dispatcher
        @driver_found = @dispatcher.find_available_driver()
      end
      
      ## WAVE 1-3 TESTS (PRE-INTELLIGENT DRIVER ASSIGNMENT)
      # it "finds an available driver" do
      #   expect(@driver_found.name).must_equal "Driver 2"
      # end
      
      # it "finds the first available driver" do 
      #   expect(@driver_found.name).wont_equal "Driver 3 (no trips)"
      # end
      
      it "The first available driver has the status :AVAILABLE" do
        expect(@driver_found.status).must_equal :AVAILABLE
      end
      
      it "Reassigns status when driver is chosen" do
        @dispatcher.request_trip(1)
        expect(@driver_found.status).must_equal :UNAVAILABLE
      end
      
      it "Raises ArgumentError if no available drivers" do
        def build_unavailable_test_dispatcher
          return RideShare::TripDispatcher.new(
            directory: UNAVAILABLE_TEST_DATA
          )
        end
        dispatcher = build_unavailable_test_dispatcher
        expect {
          dispatcher.request_trip(1)
        }.must_raise ArgumentError
      end
    end
    
    describe "find find available driver intelligent assignment" do
      before do
        @dispatcher = build_test_dispatcher
      end
      # From the Drivers that remain, select the one who has never driven or whose most recent trip ended the longest time ago
      
      it "selects first the driver with no previous trips, then the driver with the least recent most-recent trip" do
        
        # first: select the driver with no previous trips
        first_driver_found = @dispatcher.find_available_driver()
        
        first_passenger = @dispatcher.find_passenger(1)
        first_driver = @dispatcher.find_driver(first_driver_found.id)
        
        first_driver_trip = RideShare::Trip.new(id: 6, passenger: first_passenger, driver: first_driver, start_time: Time.new)
        first_driver.add_trip(first_driver_trip)
        
        expect(first_driver_found.name).must_equal "Driver 3 (no trips)"
        
        # second: select the driver whose most recent trip was longest ago
        second_driver_found = @dispatcher.find_available_driver()
        
        second_passenger = @dispatcher.find_passenger(2)
        second_driver = @dispatcher.find_driver(second_driver_found.id)
        
        second_driver_trip = RideShare::Trip.new(id: 6, passenger: second_passenger, driver: second_driver, start_time: Time.new)
        second_driver.add_trip(second_driver_trip)
        
        expect(second_driver_found.name).must_equal "Driver 2"
      end
      
    end
    
    describe "find available driver, nil end_time" do
      def build_nil_end_time_test_dispatcher
        return RideShare::TripDispatcher.new(
          directory: NIL_END_TIME_TEST_DATA
        )
      end
      
      it "ignores Drivers with in-progress trips" do
        dispatcher = build_nil_end_time_test_dispatcher
        passenger = dispatcher.find_passenger(1)
        driver = dispatcher.find_driver(3)
        in_progress_trip = RideShare::Trip.new(id: 6, passenger: passenger, driver: driver, start_time: Time.new)
        driver.add_trip(in_progress_trip)
        expect {
          dispatcher.request_trip(2)
        }.must_raise ArgumentError
      end
    end
    
    describe "Build a trip" do
      before do
        @dispatcher = build_test_dispatcher
        @drivers_found = @dispatcher.find_available_driver()
        @passenger = @dispatcher.find_passenger(1)
        @trip = @dispatcher.start_trip(driver: @drivers_found, passenger: @passenger)
      end
      
      it "returns an instance of trip" do
        expect(@trip).must_be_instance_of RideShare::Trip
      end
      
      it "returns a trip with a passenger instance assigned to it" do
        expect(@trip.passenger).must_be_instance_of RideShare::Passenger
      end
      
      it "returns a trip with the correct passenger" do
        expect(@trip.passenger.name).must_equal "Passenger 1"
      end
      
      it "returns nil for end time, cost, and rating" do
        expect(@trip.end_time).must_be_nil
        expect(@trip.cost).must_be_nil
        expect(@trip.rating).must_be_nil
      end
    end
    
    
    describe "Was the trip created" do
      before do
        @dispatcher = build_test_dispatcher
        @driver_found = @dispatcher.find_available_driver()
      end
      
      it "creates an instance of trip" do
        new_trip = @dispatcher.request_trip(1)
        expect(new_trip).must_be_instance_of RideShare::Trip
      end
      
      it "checks that the time is actually current" do
        cur_time = Time.new
        new_trip = @dispatcher.request_trip(1)
        expect(new_trip.start_time).must_be_close_to cur_time
      end
      
      it "adds the trip to the passenger's list of trips" do
        passenger_one = @dispatcher.find_passenger(1)
        trip_length_before = passenger_one.trips.length
        @dispatcher.request_trip(1)
        expect(passenger_one.trips.length).must_be :>, trip_length_before
      end
      
      it "Adds new trip to dispatcher's list of trips" do
        trip_length_before = @dispatcher.trips.length
        @dispatcher.request_trip(1)
        expect(@dispatcher.trips.length).must_be :>, trip_length_before
      end
      
    end
    
  end
end
