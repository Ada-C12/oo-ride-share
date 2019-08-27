require_relative 'test_helper'

describe "Passenger class" do
  
  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end
    
    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end
    
    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end
    
    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end
      
      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end
  
  describe "Net Expenditure" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Lionel", phone_number: "353-533-7678")
      @driver = RideShare::Driver.new(id: 1, name: "Georgie", vin: "12345678901234567", status: :AVAILABLE, trips: nil)
      
      # trip 1
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_1_data = {
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: start_time,
        end_time: end_time,
        cost: 23.00,
        rating: 3
      }
      @trip_1 = RideShare::Trip.new(@trip_1_data)
      @passenger.add_trip(@trip_1)
      
      # trip 2
      start_time_2 = Time.parse('2015-05-20T12:14:00+00:00')
      end_time_2 = start_time_2 + 30 * 60 # 25 minutes
      @trip_2_data = {
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: start_time_2,
        end_time: end_time_2,
        cost: 50.00,
        rating: 3
      }
      @trip_2 = RideShare::Trip.new(@trip_2_data)
      @passenger.add_trip(@trip_2)
    end
    
    
    it "Total Expenditure is a Float" do
      expect(@passenger.net_expenditures).must_be_instance_of Float 
    end
    
    it "Is greater than 0" do
      expect(@passenger.net_expenditures).must_be :>=, 0
    end
    
    it "Is correctly caclulating the total expenditure" do
      expect(@passenger.net_expenditures).must_equal 73.00
    end 
    
    it "Returns zero for no trips taken." do
      # Arrange
      gerald = RideShare::Passenger.new(id: 1, name: "Gerald", phone_number: "353-533-7678")
      expect(gerald.net_expenditures).must_equal 0
    end
    
    it "Returns negative value in the off-chance that total expenditure is in fact a negative number (you somehow earn money on the total trips)" do
      # arrange 
      georgie = RideShare::Passenger.new(id: 1, name: "Georgie", phone_number: "353-533-7678")
      georgies_driver = RideShare::Driver.new(id: 1, name: "Georgie", vin: "12345678901234567", status: :AVAILABLE, trips: nil)
      
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      trip_1_data = {
        id: 8,
        passenger: georgie,
        driver: georgies_driver,
        start_time: start_time,
        end_time: end_time,
        cost: -3.00,
        rating: 3
      }
      trip_1 = RideShare::Trip.new(trip_1_data)
      georgie.add_trip(trip_1)
      
      expect(georgie.net_expenditures).must_equal (-3.00)
    end
  end
  
  
  describe "Total Time Spent (getting driven around)" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Lionel", phone_number: "353-533-7678")
      @driver = RideShare::Driver.new(id: 1, name: "Georgie", vin: "12345678901234567", status: :AVAILABLE, trips: nil)
      
      # trip 1
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_1_data = {
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: start_time,
        end_time: end_time,
        cost: 23.00,
        rating: 3
      }
      @trip_1 = RideShare::Trip.new(@trip_1_data)
      @passenger.add_trip(@trip_1)
      
      # trip 2
      start_time_2 = Time.parse('2015-05-20T12:14:00+00:00')
      end_time_2 = start_time_2 + 30 * 60 # 30 minutes
      @trip_2_data = {
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: start_time_2,
        end_time: end_time_2,
        cost: 50.00,
        rating: 3
      }
      @trip_2 = RideShare::Trip.new(@trip_2_data)
      @passenger.add_trip(@trip_2)
    end
    
    
    it "Total Time Spent is a Integer" do
      expect(@passenger.total_time_spent).must_be_instance_of Integer 
    end
    
    it "Is greater than 0" do
      expect(@passenger.total_time_spent).must_be :>=, 0
    end
    
    it "Is correctly caclulating the total time spent" do
      expect(@passenger.total_time_spent).must_equal 3_300
    end 
    
    it "Returns zero for no trips taken." do
      #  Arrange
      gerald = RideShare::Passenger.new(id: 1, name: "Gerald", phone_number: "353-533-7678")
      expect(gerald.total_time_spent).must_equal 0
    end
    
    
  end
  
  describe "trips property" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      @driver = RideShare::Driver.new(id: 1, name: "Georgie", vin: "12345678901234567", status: :AVAILABLE, trips: nil)
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: Time.parse("2016-08-08"),
        end_time: Time.parse("2016-08-09"),
        rating: 5
      )
      
      @passenger.add_trip(trip)
    end
    
    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end
    
    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
    
  end
end