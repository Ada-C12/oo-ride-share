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
      driver: RideShare::Driver.new(id: 1, name: "Fakey McFake", vin:'12345678901234567')
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
    
    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end
    
    it "checks if start_time is before end_time" do   
      now = Time.now
      future = Time.now + 1000
      expect {
        RideShare::Trip.new(id:500,
          passenger: nil, passenger_id: nil,
          start_time: future, end_time: now, cost: nil, rating: nil, driver_id: nil, driver: nil)
      }.must_raise ArgumentError, "end_time CANNOT be before start_time!"
    end
    
    it "checks if Trip.duration works" do
      # given example data is 25 minutes in duration
      assert(@trip.duration==25*60)
    end 

    it "Trip.duration should raise argumentError if an ongoing trip" do
      @trip_data = {
      id: 8,
      passenger: RideShare::Passenger.new(id: 1,
      name: "Ada",
      phone_number: "412-432-7640"),
      start_time: Time.now,
      end_time: nil,
      cost: 23.45,
      rating: 3,
      driver: RideShare::Driver.new(id: 1, name: "Fakey McFake", vin:'12345678901234567')
    }
      @trip = RideShare::Trip.new(@trip_data)

      expect{@trip.duration}.must_raise ArgumentError
    end
  end
end



