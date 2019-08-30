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
      return 0 if @trips == []
      
      total = 0
      @trips.each { |trip| total += trip.cost unless trip.end_time == nil }
      
      return total
    end
    
    def total_time_spent
      return 0 if @trips == []
      
      total = 0
      @trips.each { |trip| total += trip.duration unless trip.end_time == nil }
      
      return total
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
