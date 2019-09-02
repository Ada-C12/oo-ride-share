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

    def net_expenditures # return total amount of $ passenger has spent
      passenger_costs = [] # store each cost 
      self.trips.each do |trip|
          passenger_costs << trip.cost
      end
      total_cost = passenger_costs.sum
      return total_cost
    end
    
    def total_time_spent # return total amount of time passenger has spent on trips
      passenger_time = []
      self.trips.each do |trip|
        if trip.end_time != nil
          passenger_time << trip.calculate_trip_duration
        end
      end
      total_time_per_pass = passenger_time.sum
      return total_time_per_pass
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
