require_relative "test_helper"

TEST_DATA_DIRECTORY = "test/test_data"

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
             directory: TEST_DATA_DIRECTORY,
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
      expect(dispatcher.drivers).must_be_kind_of Array
    end

    it "loads the development data by default" do
      # Count lines in the file, subtract 1 for headers
      trip_count = %x{wc -l 'support/trips.csv'}.split(" ").first.to_i - 1

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
        expect { @dispatcher.find_passenger(0) }.must_raise ArgumentError
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
    describe "Trip Dispatcher class" do
      describe "request_trip method" do
        before do
          def build_test_dispatcher
            return RideShare::TripDispatcher.new(
                     directory: TEST_DATA_DIRECTORY,
                   )
          end

          @dispatcher = build_test_dispatcher
          @available_driver = @dispatcher.drivers.find { |driver| driver.status == :AVAILABLE }

          @passenger = RideShare::Passenger.new(
            id: 10,
            name: "Kyle Walls",
            phone_number: "111-111-1114",
          )

          @driver = RideShare::Driver.new(
            id: 7,
            name: "Johnny Apple",
            vin: "1C6CF40K1J3Y74UY2",
            status: :AVAILABLE,
          )
          @completed_trip = RideShare::Trip.new(
            id: 2,
            passenger_id: 10,
            driver_id: 3,
            start_time: Time.parse("2018-05-25 11:52:40 -0700"),
            end_time: Time.parse("2018-05-25 12:25:00 -0700"),
            cost: 25,
            rating: 5,
          )
          @current_trip = RideShare::Trip.new(
            id: 8,
            passenger_id: 10,
            driver_id: 6,
            start_time: Time.now,
            end_time: nil,
            cost: nil,
            rating: nil,
          )

          @passenger.add_trip(@completed_trip)
          @passenger.add_trip(@current_trip)

          @driver.add_trip(@completed_trip)
          @driver.add_trip(@current_trip)
        end

        it "will return an instance of Trip" do
          @dispatcher.request_trip(8).must_be_kind_of RideShare::Trip
        end
        it "will change driver's status to UNAVAILABLE" do
          @available_driver.change_status.must_equal :UNAVAILABLE
        end
        it "returns nil if there are no available drivers" do
          @dispatcher.drivers.each do |driver|
            driver.change_status
          end
          expect(@dispatcher.drivers.find { |driver| driver.status == :AVAILABLE }).must_equal nil
        end
        it "returns the number of trips that one passenger has taken" do
          @passenger.trips.length.must_equal 2
        end
        it "returns the number of trips added to Trip Dispatcher trips" do
          @dispatcher.trips << @current_trip
          @dispatcher.trips.length.must_equal 6
        end
        it "calculates total money spent for a passenger in an in-progress trip" do
          @passenger.net_expenditures.must_equal 25
        end
        it "calculates average rating for a driver in an in-progress trip" do
          # binding.pry
          @driver.average_rating.must_equal 5
        end
      end
    end
  end
end
