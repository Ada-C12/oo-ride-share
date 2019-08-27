require_relative 'csv_record'
require_relative 'trip'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures(passenger_id)
      n = 0
      Trip.load_all.each do |trip|
        if trip[:passenger_id] = passenger_id
          n += [:cost].to_i
        end
      end
      return n
    end

    def total_times_spent

    end

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
