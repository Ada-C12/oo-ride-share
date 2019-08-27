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
      total_amount_of_money = 0
      @trips.each do |one_trip|
        total_amount_of_money += one_trip.cost
      end
      return total_amount_of_money.to_f.round(2)
    end
    
    def total_time_spent
      total_time = 0
      @trips.each do |one_trip|
        total_time += one_trip.duration_calculation
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
