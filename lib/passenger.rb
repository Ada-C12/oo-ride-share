require_relative 'csv_record'


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
      costs = []
      trips.each do |trip|
        costs << trip.cost
      end
      return total_cost = costs.sum
    end
    
    def total_time_spent
      times = []
      trips.each do |trip|
        times << trip.duration
      end
      return total_time = times.sum
    end
    
    private
    
    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
    
    # Add an instance method, net_expenditures, to Passenger that will return the total amount of money that passenger has spent on their trips
    
    
  end
end
