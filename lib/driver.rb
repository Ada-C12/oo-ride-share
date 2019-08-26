require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
    def initialize (id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      
      @name = name
      @vin = vin
      raise ArgumentError, "Invalid VIN" if @vin.length != 17
      @status = status
      raise ArgumentError, "Invalid status" unless [:AVAILABLE, :UNAVAILABLE].include?(@status)
      @trips = trips || []
    end
    
    
    private
    
    def self.from_csv(record)
      #id,name,vin,status
      return self.new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
    
  end
end
