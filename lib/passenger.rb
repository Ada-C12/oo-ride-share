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
      costs = trips.map do |trip|
        trip.cost
      end
      return total_cost = costs.sum
    end
    
    def total_time_spent
      times = trips.map do |trip|
        trip.duration
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
    
  end
end
