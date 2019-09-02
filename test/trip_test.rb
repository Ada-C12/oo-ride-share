require 'time'
require_relative 'test_helper'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver_id: 6
      }
      @trip = RideShare::Trip.new(@trip_data)
      
      
      it "raises an error For end times that are earlier than start times" do
        # arrange and act
        start_time = Time.parse("2019-01-09 08:48:50 -0800")
        end_time = Time.parse("2019-01-09 08:30:31 -0800")
        # assert
        @trip_data = {
          id: 8,
          passenger: RideShare::Passenger.new(
            id: 1,
            name: "Ada",
            phone_number: "412-432-7640"
          ),
          
          start_time: start_time,
          end_time: end_time,
          cost: 23.45,
          rating: 3,
          driver_id: 4
        }
        expect do
          if end_time < start_time
          end.must_raise ArgumentError #RideShare::Trip.new()
          # @trip = RideShare::Trip.new(@trip_data)
        end
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
      
      it "raises an error For an invalid rating" do
        [-3, 0, 6].each do |rating|
          @trip_data[:rating] = rating
          expect do
            RideShare::Trip.new(@trip_data)
          end.must_raise ArgumentError
        end
      end
    end
  end
  
  describe "duration of trip in seconds" do
    it "calculates the duration of the trip" do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = Time.parse("2015-05-20T12:15:00+00:00")
      @trip_data = { id: 8, driver_id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"),
          start_time: start_time,     
          end_time: end_time,      
          cost: 23.45,
          rating: 3
        }
        trip = RideShare::Trip.new(@trip_data)
        expect(trip.calculate_trip_duration).must_equal 60
      end
    end
  end
  
  
  
  
  