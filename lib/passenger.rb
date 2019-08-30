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
  
    # create method net_expenditures
    def net_expenditures
      total_money_spent = 0
      if trips.length == 0
        raise ArgumentError, "Passenger has 0 ride expenses, due to taking 0 rides."
      else
        @trips.each do |trip|
          if trip.cost != nil
            total_money_spent += trip.cost
          end
        end
        return total_money_spent
      end
    end
    
    def total_time_spent 
      total_time_spent = 0 
      if trips.length == 0
        raise ArgumentError, "No trips loaded for this passenger."
      else 
        @trips.each do |trip|
          if trip.end_time != nil
            total_time_spent += trip.duration
          end 
        end 
      end 
      return total_time_spent
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
