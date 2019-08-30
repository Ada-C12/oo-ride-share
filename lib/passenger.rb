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
      #return total amount of money that passenger has spent on their trips
      total = 0
      @trips.each do |trip|
        unless trip.cost == nil
          total += trip.cost
        end
      end
      return total
    end
    
    def total_time_spent
      total_time = 0
      
      if @trips.length == 0
        raise ArgumentError.new "Passenger has taken nil trips"
      else
        @trips.each do |trip|
          unless trip.end_time == nil
            total_time += trip.duration
          end
        end
        return total_time
      end
      
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
