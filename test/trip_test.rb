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

        driver: RideShare::Driver.new(id: 2,
                                      name: "Bob Walsh",
                                      vin: "WBS76FYD47DJF7206",
                                      status: :AVAILABLE),

        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,

      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      # Unskip after wave 2
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
  end

  it "raises an argument error if start time is higher than end time" do
    expect do
      RideShare::Trip.new(id: 1,
                          passenger_id: 5,
                          driver_id: 5,
                          start_time: Time.parse("2018-12-27 03:38:08 -0800"),
                          end_time: Time.parse("2018-12-27 02:39:05 -0800"),
                          cost: 10,
                          rating: 4)
    end.must_raise ArgumentError
  end
end
describe "Trip class" do
  describe "Duration method" do
    it "will return the difference between start and end times" do
      expect do
        trip = RideShare::Trip.new(id: 1,
                                   passenger_id: 5,
                                   driver_id: 5,
                                   start_time: Time.parse("2018-12-27 02:39:05 -0800"),
                                   end_time: Time.parse("2018-12-27 03:38:08 -0800"),
                                   cost: 10,
                                   rating: 4)

        trip.duration.must_equal 3543.0
      end
    end
  end
end
