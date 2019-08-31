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
      expenditures = 0
      @trips.each do |trip|
        expenditures += trip.cost
      end
      return expenditures
    end

    def total_time_spent
      # return the total amount of time that passenger spent on their trips
      total_time = 0
      @trips.each do |trip|
        if !trip.end_time.nil?
          total_time += trip.duration
        end
      end
      return total_time
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               phone_number: record[:phone_num],
             )
    end
  end
end
