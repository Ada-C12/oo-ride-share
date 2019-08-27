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
      # CHECK we know the number of trips this passenger has taken 
      # CHECK we need to use Trips to get access to the cost of each trip
      # CHECK we need to pair each trip with it's cost based off of a common value; like ID
      # CHECK add all the trips into an array
      # add all the costs into an array 
      # sum all the trip costs an return the total spent
      
      
      
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
