require_relative 'csv_record'

###JULIA### entire file added for Wave2

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      # using superclass CsvRecord's initialize() to validate id
      super(id)
      
      @name = name
      
      if vin.class == String && vin.length == 17
        @vin = vin
      else
        raise ArgumentError, "VIN must be string of length 17"
      end
      
      @status = status.to_sym
      @trips = trips || []
    end
    
    ###JULIA### ADDED for Wave2: Loading Drivers
    def add_trip(trip)
      @trips << trip
    end
    
    
    
    
    
    
    
    
    
    
    
    
    private
    
    def self.from_csv(record)
      # looks at the arg hash record = {id:xxx, name:xxx, vin:xxx, status:XXX}
      # returns Trip.new() object with args above and default nil on trips
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status:record[:status]
      )
    end
  end
end
