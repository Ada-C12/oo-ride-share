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
    
    def ignore_incomplete_trips(trips)
      if trips.empty?
        return []
      end
      copy_of_trips = trips.dup
      copy_of_trips.delete_if do |trip|
        trip.end_time == nil
      end
      return copy_of_trips
    end
    
    def net_expenditures
      total_spending = 0
      unless @trips.empty?
        ignore_incomplete_trips(@trips).each do |trip|
          total_spending += trip.cost
        end
      end
      return total_spending
    end
    
    def total_time_spent
      total_time = 0
      unless trips.empty?
        ignore_incomplete_trips(@trips).each do |trip|
          total_time += trip.duration
        end
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