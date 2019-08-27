require_relative 'test_helper'
require 'time'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
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
  
  describe "from_csv" do
    it "checks end time is after the start time" do
      timestart = Time.parse("2018-12-27 02:39:05 -0800")
      timeend = Time.parse("2018-12-17 16:09:21 -0800")
      passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640")
      
      expect do 
        RideShare::Trip.new(
          id: 8,
          passenger: passenger,
          start_time:timestart, 
          end_time:timeend, 
          cost: 23 , 
          rating: 3
        )
      end.must_raise ArgumentError
    end
  end
  
  describe "Duration of trip in seconds" do
    it "calculates the duration of trip in seconds" do
      time1 = Time.parse("2018-12-17 02:39:05 -0800")
      time2 = Time.parse("2018-12-17 5:09:21 -0800")
      passenger = RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640")
      testtrip = RideShare::Trip.new(
        id: 8,
        passenger: passenger,
        start_time:time1, 
        end_time:time2, 
        cost: 23 , 
        rating: 3
      )
      expect(testtrip.duration).must_equal 9016.0
    end
  end
  
  
  
  
  
end 
