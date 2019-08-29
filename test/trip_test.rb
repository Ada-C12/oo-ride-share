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
        driver: RideShare::Driver.new(id: 1, name: "Melissa", vin: "1234567890abcdefg", status: :UNAVAILABLE)
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
      # skip # Unskip after wave 2
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
    
    describe "Wave 1 - Time" do
      it "returns start time and end time as instances of Time" do
        trip = RideShare::Trip.from_csv(id: 8,
        passenger_id: 1, start_time: '2018-06-11 22:22:00 -0700',
        end_time: '2018-06-11 23:22:00 -0700', cost: 23.45, rating: 3, driver_id: 1)
        
        expect(trip.start_time).must_be_instance_of Time
        expect(trip.end_time).must_be_instance_of Time
      end
      
      it "raises ArgumentError if end-time is before start time" do
        expect { RideShare::Trip.new(id: 8,
        passenger_id: 1, start_time: '2018-06-11 23:22:00 -0700',
        end_time:'2018-06-11 22:22:00 -0700', cost: 23.45, rating: 3) }.must_raise ArgumentError
      end 
      
      it "gives the difference in seconds between start_time and end_time" do
        trip = RideShare::Trip.new(id:8, passenger_id: 1, start_time: Time.parse('2018-12-17 16:09:21 -0800'), end_time: Time.parse('2018-12-17 16:42:31 -0800'), cost: 22.22, rating: 3, driver_id: 1)
        
        difference = trip.calculate_duration
        
        expect(difference).must_equal 1990
      end    
    end
  end
end
