require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(directory: TEST_DATA_DIRECTORY)
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
    
    describe "request trip method" do
      before do
        @dispatcher = build_test_dispatcher
      end
      
      it "correctly creates a new trip" do
        existing_trips = @dispatcher.trips.count
        new_trip = @dispatcher.request_trip(5)
        
        expect(new_trip).must_be_kind_of RideShare::Trip
        expect(new_trip.id).must_equal (existing_trips + 1)
        expect(@dispatcher.trips.count).must_equal (existing_trips + 1)
      end      
      
      it "correctly updates the driver" do
        new_trip = @dispatcher.request_trip(7)
        
        expect(new_trip.driver_id).must_equal 3
        expect(new_trip.driver.status).must_equal :UNAVAILABLE
        expect(new_trip.driver.trips.length).must_equal 1
      end
      
      it "correctly updates the passenger" do
        new_trip = @dispatcher.request_trip(7)
        
        expect(new_trip.passenger.id).must_equal 7
        expect(new_trip.passenger.trips.length).must_equal 2
      end
      
      it "raises an Argument Error if there are no available drivers" do
        @dispatcher.request_trip(1)
        @dispatcher.request_trip(2)
        
        expect { @dispatcher.request_trip(3) }.must_raise ArgumentError
      end
    end
    
    describe "select_driver method" do
      before do
        @dispatcher = build_test_dispatcher
        driver4 = RideShare::Driver.new(id: 4, name: "Driver 4", vin: "12345678901234567", status: :AVAILABLE)
        new_trip = RideShare::Trip.new(
          id: 6, 
          driver: driver4, 
          passenger_id: 5, 
          start_time: Time.parse("August 6, 2018"), 
          end_time: Time.parse("August 6, 2018"),
          cost: 5,
          rating: 5
        )
        @dispatcher.drivers << driver4
        @dispatcher.trips << new_trip
      end
      
      it "selects new drivers, then drivers with oldest last trip, then error if nobody is available" do
        trip_a = @dispatcher.request_trip(1)
        trip_b = @dispatcher.request_trip(2)
        trip_c = @dispatcher.request_trip(3)
        
        # Driver 3 has no trips
        expect(trip_a.driver_id).must_equal 3
        
        # Driver 4's last trip was 8/6/18
        expect(trip_b.driver_id).must_equal 4
        
        # Driver 2's last trip was 8/12/18
        expect(trip_c.driver_id).must_equal 2
        
        # The only driver left is Driver 1, but they are unavailable, so it should throw an error
        expect{ @dispatcher.request_trip(4) }.must_raise ArgumentError
      end
    end
  end
end
