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
        driver: RideShare::Driver.new(id: 1,
                                      name: "Grace",
                                      vin: "12345678901234567",
                                      status: :AVAILABLE),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
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
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    it "raises an ArgumentError when end time is earlier than start time" do
      start_time = "2019-08-26 04:00:00 -0800"
      end_time = "2019-08-26 03:50:00 -0800"
      expect {RideShare::Trip.new(start_time, end_time)}.must_raise ArgumentError
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

  describe "duration" do
    it "calculate duration of trips in seconds" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        driver: RideShare::Driver.new(id: 1,
                                      name: "Grace",
                                      vin: "12345678901234567",
                                      status: :AVAILABLE),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)
      expect (@trip.duration).must_equal 1500
    end
  end  
end
