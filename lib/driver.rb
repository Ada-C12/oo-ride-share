require_relative 'csv_record'

DRIVER_STATUSES = [:AVAILABLE, :UNAVAILABLE]

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      @status = status
      @trips = trips || []
      
      unless @vin.length == 17
        raise ArgumentError, "VIN is not the right length."
      end
      
      unless DRIVER_STATUSES.include? status
        raise ArgumentError, "Driver status is invalid."
      end
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      return 0 if @trips.length == 0
      return @trips.sum {|trip| trip.rating} / @trips.length.to_f
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
