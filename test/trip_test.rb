require_relative "test_helper"

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        driver: RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE,
          trips: [],
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_instance_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_instance_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      expect(@trip.driver).must_be_instance_of RideShare::Driver
    end

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end
    it "raises an error for invalid time input" do
      @trip_data[:start_time] = Time.parse("2018-11-20 05:39:50 -0800,2018-11-20 06:28:10 -0800")
      @trip_data[:end_time] = Time.parse("2018-11-20 03:39:50 -0800,2018-11-20 06:28:10 -0800")
      expect do
        RideShare::Trip.new(@trip_data)
      end.must_raise ArgumentError
    end
  end
  describe "duration" do
    it "returns the difference between start and end time" do
      start_time = "2018-12-31 14:35:22 -0800"
      end_time = "2018-12-31 15:22:40 -0800"
      trip_data = RideShare::Trip.new(id: 558, passenger_id: 141, start_time: start_time, end_time: end_time, cost: 6, rating: 5)
      duration = trip_data.duration_in_seconds(start_time, end_time)
      expect(duration).must_equal 2838.0
    end
  end
end
