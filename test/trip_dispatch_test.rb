require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'

describe "TripDispatcher class" do
  ###### HELPER FCN FOR ASSEMBLING TEST DATA ######
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
      directory: TEST_DATA_DIRECTORY
    )
  end
  
  def get_random_passenger(tripDispatcherInstance, passenger_list_length = 8)
    # tripDispatcherInstance is the returned product from build_test_dispatcher above
    # we know from test/test_data files that passengers.csv has 8 fake people on it
    random_passenger = @dispatcher.passengers[rand(passenger_list_length)]
    return random_passenger
  end
  ############### end helper fcns ################
  
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
  
  ###JULIA### added entire block for wave 3
  describe "Testing .request_trip()" do
    before do
      @dispatcher = build_test_dispatcher
      @random_passenger = get_random_passenger(@dispatcher)
    end
    
    it "driver.status started as :AVAILABLE, then :UNAVAILABLE after being chosen" do
      # assemble hash for before-after comparison
      drivers_status_before = {}
      @dispatcher.drivers.each do |driver|
        drivers_status_before[driver.id] = driver.status
      end
      
      new_trip = @dispatcher.request_trip(@random_passenger.id)
      driver_after = new_trip.driver
      
      expect(drivers_status_before[driver_after.id]).must_equal :AVAILABLE, "Must only select an :AVAILABLE driver!"
      expect(driver_after.status).must_equal :UNAVAILABLE, "Must switch driver to :UNAVAILABLE!"
    end
    
    it "creates a new instance of Trip" do
      new_trip = @dispatcher.request_trip(@random_passenger.id)
      assert(new_trip.class == RideShare::Trip) 
    end
    
    it "CHECKING arg 1: new instance of Trip has correct id#" do
      # expecting id= 6 b/c we know there are 5 existing trips in the test data folder
      new_trip = @dispatcher.request_trip(@random_passenger.id)
      assert(new_trip.id == 6)
    end    
    
    it "CHECKING the other 8 args: other arg values applied correctly" do
      new_trip = @dispatcher.request_trip(@random_passenger.id)
      assert(new_trip.start_time.class == Time, msg = "start_time must be a Time obj")
      assert(new_trip.end_time == nil, msg = "end_time must be nil")
      assert(new_trip.cost == nil, msg = "cost must be nil")
      assert(new_trip.rating == nil, msg = "rating must be nil")
      
      assert(new_trip.passenger_id == @random_passenger.id, msg = "new_trip.passenger_id should be the same as the arg in request_trip(passenger_id)")
      assert(new_trip.passenger.id == @random_passenger.id, msg = "new_trip.passenger instance should have same id as the arg in request_trip(passenger_id)")
      assert(new_trip.passenger.class == RideShare::Passenger, msg = "new_trip.passenger must be instance of Passenger")
      
      assert(new_trip.driver.id == new_trip.driver_id, msg = "new_trip.driver instance should have same id as new_trip.driver_id")
      assert(new_trip.driver.class == RideShare::Driver, msg = "new_trip.driver must be instance of Driver")
    end
    
    it "new trip instance exists in driver's @trips" do 
      new_trip = @dispatcher.request_trip(@random_passenger.id)
      driver = new_trip.driver
      assert(driver.trips.include? new_trip) 
    end
    
    it "new trip instance exists in passenger's @trips" do 
      new_trip = @dispatcher.request_trip(@random_passenger.id)
      passenger = new_trip.passenger
      assert(passenger.trips.include? new_trip) 
    end
    
    it "new trip instance exists in tripDispatcher's @trips" do
      new_trip = @dispatcher.request_trip(@random_passenger.id) 
      assert(@dispatcher.trips.include? new_trip) 
    end
    
    it "what if there were no :AVAILABLE drivers?" do 
      @dispatcher.drivers.each do |driver|
        if driver.status == :AVAILABLE
          driver.switch_status
        end
      end
      new_trip = @dispatcher.request_trip(@random_passenger.id) 
      
      assert(new_trip == nil, msg = "expecting nil if no :AVAILABLE drivers") 
    end
  end
end
