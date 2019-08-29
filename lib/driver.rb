require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    #how to make status one of the types above
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips:nil)
      super(id)

      @name = name 
      @vin = vin
      @status = status.to_sym
      @trips = trips || []

      if vin.length != 17
        raise ArgumentError.new('Invalid vin')
      end 

      valid_statuses = %i[AVAILABLE UNAVAILABLE]
      if valid_statuses.include?(@status) == false
        raise ArgumentError.new "Invalid status."
      end 
    end 

    def add_trip(trip)
      @trips << trip
    end

    def total_revenue
      revenue_per_trip = []
      @trips.each do |trip|
        revenue_per_trip << (trip.cost - 1.65)*0.8
      end  
      total_revenue = revenue_per_trip.sum
    end 

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status],
        trips:  record[:trips]
      )
    end

  end 
end 
