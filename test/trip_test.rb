require_relative 'test_helper'
require 'time'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      driver = RideShare::Driver.new(id:1, name: "Emily", vin: "WBS76FYD47DJF7206", status: :AVAILABLE, trips: nil)
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver_id: 1,
        driver: driver
      }
      @trip = RideShare::Trip.new(@trip_data)
    end
    
    it "Is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end
    
    it "Stores an instance of Passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end
    
    it "Stores an instance of Driver" do
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end
    
    it "Raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end
  end
  
  describe "from_csv" do
    before  do
      @timestart = Time.parse("2018-12-17 02:39:05 -0800")
      @timeend = Time.parse("2018-12-17 5:09:21 -0800")
      @passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640")
      @driver = RideShare::Driver.new(id: 1, name: "Emily", vin: "WBS76FYD47DJF7206", status: :AVAILABLE, trips: nil)
      
    end
    it "checks end time is after the start time" do
      timestart = Time.parse("2018-12-27 02:39:05 -0800")
      timeend = Time.parse("2018-12-17 16:09:21 -0800")
      expect do 
        RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          start_time:timestart, 
          end_time:timeend, 
          cost: 23 , 
          rating: 3,
          driver_id: 1,
          driver: @driver
        )
      end.must_raise ArgumentError
    end
  end
  
  describe "Duration of trip in seconds" do
    before  do
      @timestart = Time.parse("2018-12-17 02:39:05 -0800")
      @timeend = Time.parse("2018-12-17 5:09:21 -0800")
      @passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640")
      @driver = RideShare::Driver.new(id: 1, name: "Emily", vin: "WBS76FYD47DJF7206", status: :AVAILABLE, trips: nil)
    end
    
    it "calculates the duration of trip in seconds" do
      testtrip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time:@timestart, 
        end_time:@timeend, 
        cost: 23 , 
        rating: 3,
        driver_id: 1,
        driver: @driver
      )
      expect(testtrip.duration).must_equal 9016.0
    end
  end
end 
