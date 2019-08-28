require 'csv'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      raise ArgumentError if vin.length != 17
      raise ArgumentError unless status == :AVAILABLE || status == :UNAVAILABLE

      @name = name
      @vin = vin
      @status = status
      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      @trips.empty? ? 0 : @trips.map(&:rating).sum / @trips.length.to_f
    end

    def total_revenue
      @trips.map do |trip|
        trip_revenue = (trip.cost - 1.65) * 0.8
        
        if trip_revenue > 0
          trip_revenue
        else
          raise ArgumentError
        end
      end.sum
    end

    def dispatch(trip)
      add_trip(trip)
      @status = :UNAVAILABLE
    end

    private
    
    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
        )
    end
  end
end
