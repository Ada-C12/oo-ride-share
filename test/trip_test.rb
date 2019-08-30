require_relative 'test_helper'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver_id: 6
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "raises ArgumentError if end_time is before start_time" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      
      trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        end_time: start_time,
        start_time: end_time,
        cost: 23.45,
        rating: 3,
        driver_id: 6
      }
      
      expect { RideShare::Trip.new(trip_data) }.must_raise ArgumentError
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      # we modified this test because the connect method needed to be called in TripDispatcher
      # in order to make an instance of RideShare::Driver
      td = RideShare::TripDispatcher.new(directory: './support')
      driver = td.find_driver(@trip.driver_id)
      
      @trip.connect(@trip.passenger, driver)
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end
    
    it "calculates the duration of the trip in seconds" do
      expect(@trip.duration).must_equal 1500.0
    end
  end

  describe "from_csv" do
    it "stores start_time and end_time as instances of Time" do
      trips = RideShare::Trip.load_all(directory: "test/test_data")

      trips.each do |trip|
        expect(trip.start_time).must_be_instance_of Time
        expect(trip.end_time).must_be_instance_of Time
      end
    end
  end
end
