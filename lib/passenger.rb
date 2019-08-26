require_relative 'csv_record'
require_relative 'trip'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips
    
    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)
      
      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def net_expenditures 
      
      total = @trips.sum do |trip|
        trip.cost
      end 
      return total 
    end 
    # 1.	Add an instance method, net_expenditures, 
    #to Passenger that will return the total amount of money that passenger has spent on their trips
    private
    
    def self.from_csv(record)
      return new(
      id: record[:id],
      name: record[:name],
      phone_number: record[:phone_num]
      )
    end
  end
end


@passenger = RideShare::Passenger.new(
id: 9,
name: "Merl Glover III",
phone_number: "1-602-620-2330 x3723",
trips: []
)
trip1 = RideShare::Trip.new(
id: 8,
passenger: @passenger,
start_time: "2016-08-08",
end_time: "2016-08-09",
cost: 5,
rating: 5
)

trip2 = RideShare::Trip.new(
id: 6,
passenger: @passenger,
start_time: "2016-08-02",
end_time: "2016-08-09",
cost: 10,
rating: 5
)

@passenger.add_trip(trip1) 
@passenger.add_trip(trip2)

puts @passenger.net_expenditures
