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
      rating: 3,
      driver: RideShare::Driver.new(id: 3,
      name: "Katherine",
      vin: "MP97K0AY5U7G2CHPM",
      status: :AVAILABLE,
      trips: nil
      ) }
      
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
    
    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect{RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
      end
    end
    
    it "raises an ArgumentError if end time is before start time; ignores trips in-progress" do
      @trip_data[:end_time] = @trip_data[:start_time] - 25 * 60
      expect{RideShare::Trip.new(@trip_data)}.must_raise ArgumentError

      @trip_data[:end_time] = nil
      new_trip = RideShare::Trip.new(@trip_data)
      expect(new_trip.end_time).must_be_nil
    end

  end
  
  describe "duration" do
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
      rating: 3,
      driver_id: 3 }
    end
  
    it "calculates the total trip time" do
      trip = RideShare::Trip.new(@trip_data)
      result = trip.duration
      expect(result).must_equal 1500
    end
  
    it "returns 0 if start and end time were the same" do
      @trip_data[:end_time] = @trip_data[:start_time]
      trip = RideShare::Trip.new(@trip_data)
      result = trip.duration
      expect(result).must_equal 0
    end

    it "returns 0 as the duration of trips in-progress" do
      @trip_data[:end_time] = nil
      @trip_data[:cost] = nil
      @trip_data[:rating] = nil

      trip = RideShare::Trip.new(@trip_data)
      result = trip.duration

      expect(result).must_equal 0
    end
  end
end
