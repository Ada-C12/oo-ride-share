require_relative 'csv_record'
require 'time'

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
      if @trips.length > 0 
        total_trips = @trips.map do |trip|
          trip.cost
        end
        total_trips.sum
      else 
        raise ArgumentError 
      end 
    end
    
    def total_time_spent 
      if @trips.length > 0
        total_time = @trips.map do |trip|
          trip.calculate_duration
        end 
        total_time.sum 
      else
        raise ArgumentError
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
