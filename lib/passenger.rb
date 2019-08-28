require_relative 'csv_record'

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

    #that will return the _total amount of money_ that passenger has spent on their trips
    def net_expenditures
      total = 0

      @trips.each do |trip|
        total += trip.cost 
      end
      return total 
    end

    #that will return the _total amount of time_ that passenger has spent on their trips
    def total_time_spent
      total = 0

      @trips.each do |trip|
        total += trip.duration_in_seconds
      end
      return total 
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
