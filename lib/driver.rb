require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord 

    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: AVAILABLE, trips: nil)
      super(id)
      @name = name
      @status = status
      @trips = trips || []

      if vin.length == 17
        @vin = vin 
      else
        raise ArgumentError
      end
    end


    def add_trip(trip)
      @trips << trip
    end
    # Since `Driver` inherits from `CsvRecord`, you'll need to implement the `from_csv` template method. Once you do, `Driver.load_all` should work (test this in pry).
    private 
    
    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status],
        trips: record[:trips]
      )
    end
  end
end




