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
        driver: RideShare::Driver.new(id: 5, name: "V", vin:"12345678976543346", status: "AVAILABLE")
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    #pass in data that will make it fail

    it "raises an error if the end time is before the start time" do
      start_time = Time.parse('2019-04-23T15:03:00+00:00')
      end_time = Time.parse('2019-04-23T12:10:00+00:00')

      @trip_data = {
        id: 1, 
        passenger: RideShare::Passenger.new(id:8,
                                            name: "Sara",
                                            phone_number: "983-584-0908"),
        start_time: start_time, 
        end_time: end_time,
        cost: 5.87,
        rating: 4,
        driver: RideShare::Driver.new(id: 5, name: "V", vin:"12345678976543346", status: "AVAILABLE")
        }

      expect{RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
    end 

    #Add an instance method to the `Trip` class to calculate the _duration_ of the trip in seconds, **and a corresponding test**
    #Passed in trip information initialized at top of test
    #Total duration was 25min * 60sec = 1500 seconds
    it "calculates the trip duration in seconds" do
      expect(@trip.duration_in_seconds).must_equal 1500 
    end

    it "stores an instance of driver" do
      skip # Unskip after wave 2
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
end
