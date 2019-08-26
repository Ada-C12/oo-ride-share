require_relative 'csv_record'
DRIVER_STATUSES = [:AVAILABLE, :UNAVAILABLE]

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      @name = name
      @vin = vin
      @status = status
      @trips = trips
      
      unless @vin.length == 17
        raise ArgumentError, "VIN is not the right length."
      end
      
      unless DRIVER_STATUSES.include? status
        raise ArgumentError, "Driver status is invalid."
      end
    end
    
    private
    
    def self.from_csv(record)
      return self.new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status],
        trips: record[:trips]
      )
    end
    
    
    
  end
end
