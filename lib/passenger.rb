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
      raise ArgumentError.new "No trips for this passenger." if @trips == [] || @trips == nil 
      trip_cost = @trips.map do |trip|
        trip.cost
      end
      return trip_cost.sum
      
    end
    
    def total_time_spent
      raise ArgumentError.new "No trips for this passenger." if @trips == [] || @trips == nil 
      time_spent = 0
      trip_cost = @trips.map do |trip|
        time_spent += trip.duration
      end
      return time_spent
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
