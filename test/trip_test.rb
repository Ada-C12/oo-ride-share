require_relative 'test_helper'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
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
  
  describe "duration" do
    
    it "must be a positive number" do
      # Arrange
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)
      # Act
      difference_in_time = @trip.duration
      # Assert
      expect(difference_in_time).must_be :>, 0
    end
    
    it "must raise error if zero" do
      # Arrange
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = Time.parse('2015-05-20T12:14:00+00:00')
      @new_trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @new_trip = RideShare::Trip.new(@new_trip_data)
      # Act && Assert
      expect do
        @new_trip.duration
      end.must_raise ArgumentError
    end
    
    it "must raise error if negative number" do
      # Arrange
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time - 25 * 60 # -25 minutes
      @new_trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @new_trip = RideShare::Trip.new(@new_trip_data)
      # Act & Assert
      expect do
        @new_trip.duration
      end.must_raise ArgumentError
    end
    
    it "must raise error if start/end time is nil" do
      # Arrange
      start_time = nil
      end_time = nil
      @new_trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @new_trip = RideShare::Trip.new(@new_trip_data)
      # Act & Assert
      expect do
        @new_trip.duration
      end.must_raise ArgumentError
    end
    
    it "must calculate seconds" do
      # Arrange
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @new_trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @new_trip = RideShare::Trip.new(@new_trip_data)
      # Act & Assert
      expect(@new_trip.duration).must_equal 1500
    end
  end
  
end
