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
      total_expenditure = 0
      trips.each do |trip|
        total_expenditure += trip.cost
      end
      return total_expenditure
      # loop through all the individual trips a given passenger has taken
      # increment or add all costs to a local variable called total_expenditure 
      # return total_expenditure 
    end 
    
    def total_time_spent 
      total_time = 0
      trips.each do |trip|
        total_time += trip.duration
      end
      return total_time
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
