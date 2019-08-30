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
    end
    
    it "loads the development data by default" do
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
  end
  
  describe " Request trip" do
    it "Checks to see if returns instance of trip " do
      dispatcher = build_test_dispatcher
      result = dispatcher.request_trip(1)
      expect(result).must_be_instance_of RideShare::Trip
      expect(result).wont_be_nil
      expect(result.passenger_id).must_equal 1
    end

    it "Checks to see if trip created properly" do
      dispatcher = build_test_dispatcher
      result = dispatcher.request_trip(1)
      expect(result.id).must_be_instance_of Integer
      expect(result.passenger).must_be_instance_of RideShare::Passenger
      expect(result.start_time).must_be_instance_of Time
      expect(result.end_time).must_be_nil
      expect(result.cost).must_be_nil
      expect(result.rating).must_be_nil
      expect(result.driver_id).must_be_instance_of Integer
      expect(result.driver).must_be_instance_of RideShare::Driver
    end 

    it "Drivers status should be available until added to a trip " do
      dispatcher = build_test_dispatcher
      result = dispatcher.request_trip(1)
      expect(result.driver.status).must_equal :UNAVAILABLE
    end

    it "Error should be raised if no available drivers" do
      dispatcher= build_test_dispatcher
      dispatcher.drivers.each do |driver|
        driver.status = :UNAVAILABLE
      end
      expect{dispatcher.request_trip(1)}.must_raise ArgumentError
    end
    
    it " Were the trip added to the total list of trips" do
      dispatcher = build_test_dispatcher
      num_trips = dispatcher.trips.length
      result = dispatcher.request_trip(1)
      new_num_trips = num_trips + 1
      result = dispatcher.trips.length
      expect(result).must_equal new_num_trips
    end

    it " Were the trip lists for the driver updated" do
      dispatcher = build_test_dispatcher
      driver = dispatcher.find_first_available_driver
      num_trips = driver.trips.length
      result = dispatcher.request_trip(1)
      new_num_trips = num_trips + 1
      final_result = result.driver.trips.length
      expect(final_result).must_equal new_num_trips 
    end

    it " Were the trip lists for passenger updated" do
      dispatcher = build_test_dispatcher
      passenger = dispatcher.find_passenger(1)
      num_trips = passenger.trips.length
      result = dispatcher.request_trip(1)
      new_num_trips = num_trips + 1
      updated_trips = result.passenger.trips.length
      expect(updated_trips).must_equal new_num_trips
    end
  end 
  
  describe "Find first available driver" do
    it "Checks to see if find_first_available_driver method actually returns available driver" do
      dispatcher = build_test_dispatcher
      result = dispatcher.find_first_available_driver
      expect(result).must_be_instance_of RideShare::Driver
      expect(result.status).must_equal :AVAILABLE
    end
  end
end
