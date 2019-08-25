require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips
    
    def initialize(id:, name:, phone_number:, trips: nil)
      # using superclass CsvRecord's initialize() to validate id
      super(id)
      
      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    private
    
    def self.from_csv(record)
      # looks at the arg hash record = {id:xxx, name:xxx, phone_num:xxx}
      # returns new Passenger object with args above and default nil on trips
      return new(
      id: record[:id],
      name: record[:name],
      phone_number: record[:phone_num]
      )
    end
  end
end
