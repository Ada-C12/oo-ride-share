require_relative 'test_helper'

describe "Driver class" do
  describe "Driver instantiation" do
    before do
      @driver = RideShare::Driver.new(
        id: 54,
        name: "Test Driver",
        vin: "12345678901234567",
        status: :AVAILABLE
      )
    end
    
    it "is an instance of Driver" do
      expect(@driver).must_be_kind_of RideShare::Driver
    end
    
    it "throws an argument error with a bad VIN" do
      expect { RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133") }.must_raise ArgumentError
    end
    
    it "throws an argument error with a bad VIN value" do
      expect { RideShare::Driver.new(id: 100, name: "George", vin: "") }.must_raise ArgumentError
      expect { RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums") }.must_raise ArgumentError
    end
    
    it "has a default status of :AVAILABLE" do
      expect(RideShare::Driver.new(id: 100, name: "George", vin: "12345678901234567").status).must_equal :AVAILABLE
    end
    
    it "sets driven trips to an empty array if not provided" do
      expect(@driver.trips).must_be_kind_of Array
      expect(@driver.trips.length).must_equal 0
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :name, :vin, :status, :trips].each do |prop|
        expect(@driver).must_respond_to prop
      end
      
      expect(@driver.id).must_be_kind_of Integer
      expect(@driver.name).must_be_kind_of String
      expect(@driver.vin).must_be_kind_of String
      expect(@driver.status).must_be_kind_of Symbol
    end
  end
  
  describe "add_trip method" do
    before do
      pass = RideShare::Passenger.new(
        id: 1,
        name: "Test Passenger",
        phone_number: "412-432-7640"
      )
      @driver = RideShare::Driver.new(
        id: 3,
        name: "Test Driver",
        vin: "12345678912345678"
      )
      @trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: pass,
        start_time: "2016-08-08",
        end_time: "2018-08-09",
        rating: 5
      )
    end
    
    it "adds the trip" do
      expect(@driver.trips).wont_include @trip
      previous = @driver.trips.length
      
      @driver.add_trip(@trip)
      expect(@driver.trips).must_include @trip
      expect(@driver.trips.length).must_equal previous + 1
    end
  end
  
  describe "average_rating method" do
    before do
      @driver = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ"
      )
      trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger_id: 3,
        start_time: "2016-08-08",
        end_time: "2016-08-08",
        rating: 5
      )
      @driver.add_trip(trip)
    end
    
    it "returns a float" do
      expect(@driver.average_rating).must_be_kind_of Float
    end
    
    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      expect(average).must_be :>=, 1.0
      expect(average).must_be :<=, 5.0
    end

    ###JULIA### added this IT block for Wave 3
    it "returns zero if no driven trips" do
      driver_sad = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ"
      )
      expect(driver_sad.average_rating).must_equal 0
    end

    ###JULIA### added this IT block for Wave 3
    it "returns zero if 1 ongoing trip only, and no other trips" do
      ongoing_trip = RideShare::Trip.new(id:100, passenger: nil, passenger_id: 100,
        start_time:Time.now, end_time: nil, cost: nil, rating:nil, driver_id: 54, driver: nil)
      driver_newb = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        trips: [ongoing_trip]
      )
      expect(driver_newb.average_rating).must_equal 0
    end

    ###JULIA### added this IT block for Wave 3
    it "returns correct rating if 1 ongoing trip among other trips" do
      ongoing_trip = RideShare::Trip.new(id:100, passenger: nil, passenger_id: 100,
        start_time:Time.now, end_time: nil, cost: nil, rating:nil, driver_id: 54, driver: nil)
      old_trip1 = RideShare::Trip.new(id:99, passenger: nil, passenger_id: 100,
        start_time:Time.now, end_time: nil, cost: 10.00, rating:5, driver_id: 54, driver: nil)
      old_trip2 = RideShare::Trip.new(id:98, passenger: nil, passenger_id: 100,
        start_time:Time.now, end_time: nil, cost: 20.00, rating:3, driver_id: 54, driver: nil)
      driver_rookie = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        trips: [ongoing_trip, old_trip1, old_trip2]
      )
      # expecting rating 5 + rating 3 + rating nil/ongoing = 4.0 average rating
      expect(driver_rookie.average_rating).must_equal 4.0
    end
    
    it "correctly calculates the average rating" do
      trip2 = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger_id: 3,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 1
      )
      @driver.add_trip(trip2)
      
      expect(@driver.average_rating).must_be_close_to (5.0 + 1.0) / 2.0, 0.01
    end
  end
  
  ###JULIA### ENTIRE BLOCK for wave 2 
  describe "total_revenue" do
    before do
      @driver = RideShare::Driver.new(
        id: 99,
        name: "Some Guy",
        vin: "1C9EVBRM0YBC564DZ",
        trips: []
      )
      @trip1 = RideShare::Trip.new(
        id: 1,
        driver: @driver,
        passenger_id: 11,
        start_time: "2016-08-08",
        end_time: "2016-08-08",
        rating: 5,
        cost: 11.65
      )
      @trip2 = RideShare::Trip.new(
        id: 2,
        driver: @driver,
        passenger_id: 22,
        start_time: "2016-08-08",
        end_time: "2016-08-08",
        rating: 1,
        cost: 101.65
      )
      @ongoing_trip = RideShare::Trip.new(
        id:100, 
        passenger_id: 100,
        start_time:Time.now, 
        end_time: nil, 
        cost: nil, 
        rating:nil, 
        driver: @driver)
    end

    it "Returns 0 if no trips given" do
      expect(@driver.total_revenue).must_equal 0
    end

    it "Returns 0 if only 1 ongoing trip" do
      @driver.add_trip(@ongoing_trip)
      expect(@driver.total_revenue).must_equal 0
    end

    it "Returns correct Float value for trips taken" do
      @driver.add_trip(@trip1)
      @driver.add_trip(@trip2)
      correct_revenue = ((11.65-1.65) + (101.65-1.65))*0.8
      
      assert(@driver.total_revenue == correct_revenue)
    end
    
    it "Returns correct amount if 1 ongoing trip among other finished trips" do
      [@ongoing_trip, @trip1, @trip2].each do |trip|
        @driver.add_trip(trip)
      end
      manual_calc = ((11.65-1.65) + (101.65-1.65))*0.8

      expect(@driver.total_revenue).must_equal manual_calc
    end
    
    it "Returns 0 if only trip(s) taken were <= $1.65, and I chose not to penalize the driver w/ the fee" do
      trip_super_cheap = RideShare::Trip.new(
        id: 1,
        driver: @driver,
        passenger_id: 11,
        start_time: "2016-08-08",
        end_time: "2016-08-08",
        rating: 5,
        cost: 0.25
      )
      trip_cheap = RideShare::Trip.new(
        id: 2,
        driver: @driver,
        passenger_id: 22,
        start_time: "2016-08-08",
        end_time: "2016-08-08",
        rating: 1,
        cost: 1.65
      )
      @driver.add_trip(trip_super_cheap)
      @driver.add_trip(trip_cheap)
      
      assert(@driver.total_revenue == 0)
    end
    
    
    
  end
end
