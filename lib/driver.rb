require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      
      @name = name
      
      if vin.length != 17
        raise ArgumentError.new("The VIN should be 17 characters long.")
      end
      
      @vin = vin
      
      if status != :AVAILABLE && status != :UNAVAILABLE
        raise ArgumentError.new("The driver status must be available or unavailable.")
      end
      
      @status = status
      @trips = trips || []
    end
  end
  
  def self.from_csv(record)
    return new(
      id: record[:id],
      name: record[:name],
      vin: record[:vin],
      status: record[:status]
    )
  end
end
