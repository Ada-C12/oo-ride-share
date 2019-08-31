require_relative 'test_helper'

describe "Trip class" do
  before do
    start_time = Time.parse('2015-05-20T12:14:00+00:00')
    end_time = start_time + 25 * 60 # 25 minutes
    @trip_data = {
      id: 8,
      passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
      start_time: start_time,
      end_time: end_time,
      cost: 23.45,
      rating: 3,
      driver: RideShare::Driver.new(id: 20, name: "Love", vin: "lalalalalalalalal", status: :AVAILABLE)
    }
    @trip = RideShare::Trip.new(@trip_data)
  end
  
  describe "initialize" do
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
    
    it "makes the start time and end time instances of Time" do
      trip_data = RideShare::Trip.load_all(directory: 'support', file_name: 'trips.csv' )
      
      trip_data.each do |record|
        expect(record.start_time).must_be_kind_of Time
        begin
          if record.end_time != nil
            expect(record.end_time).must_be_kind_of Time
            expect(record.end_time - record.start_time).must_be :>, 0
          end
        rescue "End time was nil, cannot calculate, but it might be okay"
        end
      end
    end
    
    it "checks that the trip length of time is valid" do
      trip_data = RideShare::Trip.load_all(directory: 'support', file_name: 'trips.csv' )
      
      trip_data.each do |record|
        expect(record.end_time - record.start_time).must_be :>, 0
      end
    end
    
    it "raises an ArgumentError for invalid trip length of time" do 
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time - 25 * 60 
      trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,name: "Ada", phone_number: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver: RideShare::Driver.new(id: 100, name: "Love", vin: "lalalalalalalalal", status: :AVAILABLE)
      }
      
      expect{RideShare::Trip.new(trip_data)}.must_raise ArgumentError
    end
  end
  
  describe "duration" do
    it "calculates the trip length of time in seconds" do
      expected_time = @trip.end_time - @trip.start_time
      expect(@trip.duration).must_equal expected_time
    end
  end
  
end
