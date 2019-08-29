require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status:, trips:)
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips

      # (implement from_csv and Driver.load_all should work

      # Tests are provided to make sure an instance can be created and ArgumentError
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: name[:name],
               vin: vin[:vin],
               status: status[:status],
               trips: trips[:trips],
             )
    end
  end
end
