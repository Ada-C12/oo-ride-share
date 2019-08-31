require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      valid_statuses = [:AVAILABLE, :UNAVAILABLE]

      @name = name
      if vin.length != 17
        raise ArgumentError, "The length of VIN must be at least 17"
      else
        @vin = vin
      end

      if valid_statuses.include?(status)
        @status = status
      else
        raise ArgumentError, "Invalid status!"
      end

      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      rating = 0.00
      rating_zero = 0.00
      if @trips == []
        return 0
      else
        @trips.each do |trip|
          rating += trip.rating
        end
        @trips.each do |trip|
          if trip.rating == 0
            rating_zero += 1
          end
        end
      end
      return rating / (@trips.length - rating_zero)
    end

    def total_revenue
      total_rev = 0.00
      if @trips == []
        return 0
      else
        @trips.each do |trip|
          total_rev += trip.cost
        end
      end
      return (total_rev - 1.65) * 0.80
    end

    def change_status # helper method to change driver's status
      @status = :UNAVAILABLE
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
             )
    end
  end
end
