require_relative "csv_record"

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

    def net_expenditures
      total = 0
      @trips.each do |trip|
        total += trip.cost
      end
      return total
    end

    def total_time_spent
      total_time = 0
      @trips.each do |trip|
        duration = trip.duration_in_seconds((trip.start_time), (trip.end_time))
        total_time += duration
      end
      return total_time
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id].to_i,
               name: record[:name],
               phone_number: record[:phone_num],
             )
    end
  end
end
