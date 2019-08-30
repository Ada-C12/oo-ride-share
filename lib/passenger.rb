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
      trip_costs = []
      
      trips.each do |trip|
        if trip.end_time 
          trip_costs << trip.cost
        end
      end
      total_cost = trip_costs.sum    
    end
    
    def total_time_spent
      each_trip_duration = []
      
      trips.each do |trip|
        if trip.end_time
          each_trip_duration << trip.calculate_duration
        end
      end
      
      total_duration_seconds = each_trip_duration.sum
      total_duration_seconds / 60
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
