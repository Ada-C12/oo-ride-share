require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status:, trips:nil)
      super(id)

      @name = name 
      @vin = vin
      @status = :AVAILABLE || :UNAVAILABLE
      @trips = trips || []

      if vin.length != 17
        raise ArgumentError.new('Invalid vin')
      end 
    end 

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status],
        trips:  record[:trips]
      )
    end

  end 
end 
