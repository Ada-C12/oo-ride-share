require_relative 'test_helper'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      
      # driver_for_test = Driver.new(askdfjlsdf)
      # driver_for_test = Driver.load_all("test_data").first
      
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
        driver: RideShare::Driver.new(
          id:1,
          name: "Paul Klee",
          vin: "WBS76FYD47DJF7206",
          status: :AVAILABLE
          
        )
        
      }
      @trip = RideShare::Trip.new(@trip_data)
    end
    
    it "calculates the duration of the trip in seconds" do 
      expect(@trip.duration_calculation).must_equal 1500
      
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
    
    it "raises an error if end time is before start time" do
      start_time = Time.now
      end_time = Time.new(2019, 8, 26, 9, 0, 0)
      
      @time_checking_trip = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver: RideShare::Driver.new(
          id:1,
          name: "Paul Klee",
          vin: "WBS76FYD47DJF7206",
          status: :AVAILABLE
        )
        
      }
      
      expect do
        RideShare::Trip.new(@time_checking_trip)
      end.must_raise ArgumentError
    end
    
  end
  
  
end
