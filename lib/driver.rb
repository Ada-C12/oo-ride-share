require 'csv'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      raise ArgumentError if vin.length != 17
      raise ArgumentError unless status == :AVAILABLE || status == :UNAVAILABLE

      @name = name
      @vin = vin
      @status = status
      @trips = trips




    end


  end

end
