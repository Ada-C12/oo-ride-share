require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips
      accepted_vin_length = 17
      if @vin.length != accepted_vin_length
        raise ArgumentError.new("Invalid VIN Length")
      end

      # (implement from_csv and Driver.load_all should work

      accepted_statuses = [:UNAVAILABLE, :AVAILABLE]
      if !accepted_statuses.include? @status
        raise ArgumentError.new("Invalid Status Input")
      end

      # Tests are provided to make sure an instance can be created and ArgumentError
    end

    def add_trip(trip)
      @trips << trip
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
