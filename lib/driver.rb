require_relative 'csv_record'
DRIVER_STATUSES = [:AVAILABLE, :UNAVAILABLE]

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      @status = status
      @trips = trips || []

      raise ArgumentError, "VIN is not the right length." if @vin.length != 17

      unless DRIVER_STATUSES.include? status
        raise ArgumentError, "Driver status is invalid."
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return 0 if @trips.length == 0
      nil_counter = @trips.count {|trip| trip.rating == nil}
      if nil_counter == @trips.length
        return 0
      else
        return @trips.sum {|trip| trip.rating.to_f} / (@trips.length.to_f - nil_counter)
      end
    end

    def total_revenue
      return 0 if @trips.length == 0

      net_profit = 0
      @trips.each do |trip|
        if trip.cost > 1.65
          net_profit += trip.cost - 1.65
        end
      end
      return net_profit * 0.8
    end

    private

    def self.from_csv(record)
      return self.new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym,
        trips: record[:trips]
      )
    end
  end
end
