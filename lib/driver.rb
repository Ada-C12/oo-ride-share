require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status:, trips: nil)
      super(id)
      @id = id 
      @name = name 
      @trips = trips || []
      @status = status 
      @vin = vin 
      
      # if status == :AVAILABLE || status == :UNAVAILABLE
      #   @status = status 
      # else 
      #   raise ArgumentError 
      # end 
      # if vin.length == 17 
      #   @vin = vin 
      # else 
      #   raise ArgumentError
      # end 
      
    end
    
    
    private
    
    
    def self.from_csv(record)
      return new(
      id: record[:id],
      name: record[:name],
      vin: record[:vin],
      status: record[:status]
      )
    end
    
    
    
    
  end 
end