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
      Trip.load_all(full_path: "support/trips.csv").each do |trip|
        if trip.instance_variable_get(:@passenger_id) == passenger_id
          n += trip.instance_variable_get(:@cost).to_i
        end
      end
      return n
    end

    def total_time_spent(passenger_id)
      n = 0
      Trip.load_all(full_path: "support/trips.csv").each do |trip|
        if trip.instance_variable_get(:@passenger_id) == passenger_id
          n += trip.duration
        end
      end
      return n
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
