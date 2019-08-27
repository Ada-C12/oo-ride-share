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

    def net_expenditures
      #return total amount of money that passenger has spent on their trips
      total = 0
      @trips.each do |trip|
        total += trip.cost
      end
      return total
    end

    def total_time_spent
      #return the total amount of time that passenger has spent on their trips
      total_time = 0

      if @trips.length == 0
        raise ArgumentError.new "Passenger has taken nil trips"
      else
        @trips.each do |trip|
          duration = (trip.end_time - trip.start_time)*3600
          total_time += duration
        end
        total_time = ((total_time / 60).round(2))/60 #60 minutes in hour
        return total_time
      end
    
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
