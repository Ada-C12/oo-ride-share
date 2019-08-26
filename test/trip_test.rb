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
  
  it "makes the start time and end time instances of Time" do
    trip_data = {
    id: 1000,
    driver_id: 17,
    passenger_id: 25,
    start_time: '2019-01-09 08:48:50 -0800',
    end_time: '2019-01-09 08:52:50 -0800',
    cost: 23.45,
    rating: 3
  }
  
  
  expect(RideShare::Trip.from_csv(trip_data).start_time).must_be_kind_of Time
  expect(RideShare::Trip.from_csv(trip_data).end_time).must_be_kind_of Time
  
end
end
end
