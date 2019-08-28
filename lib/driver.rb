# Wave 2
require_relative 'csv_record'
require 'pry'

module RideShare
  # inherits from CsvRecord (similar to Trip & Passenger)
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      # Pass to the superclass constructor (CsvRecord) similar to Passenger
      super(id)
      
      #:id, unique number for this driver
      # @id = id:
      
      #:name, driver's name
      @name = name
      
      #:vin, driver's VIN
      # String length of 17. Raise ArgumentError if it's wrong length.
      @vin = vin
      if @vin.length != 17
        raise ArgumentError
      else
        @vin = vin
      end
      
      #:status, Is this Driver available to drive?
      # Must be one of :available or :unavailable
      @status = status

      valid_status = %i[AVAILABLE UNAVAILABLE]
      if valid_status.include?(@status)
        @status = status
      else
        raise ArgumentError
      end

      #:trips, A list of trips this driver has driven
      # Optional, if not provided, initialize to an empty array (similar to Passenger)
      # @trips = trips || []
      @trips = trips || []
    end

    private

    #def self.from_csv()
    # Driver.load_all
    # def self.from_csv(record)
    #   return self.new(
    #   id: record[:id],
    #   name: record[:name],
    #   vin: record[:vin],
    #   status: record[:status]
    #   )
    # end
  end
end
