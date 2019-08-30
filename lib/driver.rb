require 'csv'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      raise ArgumentError, "Invalid vin length" if vin.length != 17
      raise ArgumentError, "Invalid status" unless 
        status == :AVAILABLE || status == :UNAVAILABLE

      @name = name
      @vin = vin
      @status = status
      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if completed_trips.empty? 
        return 0 
      else 
        return completed_trips.map(&:rating).sum / completed_trips.length.to_f
      end
    end

    def total_revenue
      completed_trips.map do |trip|
        trip_revenue = (trip.cost - 1.65) * 0.8
        
        if trip_revenue > 0
          trip_revenue
        else
          raise ArgumentError, "#{trip} has negative revenue"
        end
      end.sum
    end

    def dispatch(trip)
      raise ArgumentError, "Driver unavailable" if @status == :UNAVAILABLE
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

    def completed_trips
      @trips.select(&:end_time)
    end
  end
end
