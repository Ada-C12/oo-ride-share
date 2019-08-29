require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      
      @name = name
      
      raise ArgumentError.new if vin.length != 17
      @vin = vin
      
      raise ArgumentError.new if ![:AVAILABLE, :UNAVAILABLE].include?(status)
      @status = status
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      total_rating = 0
      
      @trips.each do |trip|
        total_rating += trip.rating
      end
      
      return 0 if @trips.empty?
      ave_rating = total_rating.to_f/@trips.length
      return ave_rating.round(1)
    end
    
    def total_revenue
      total_revenue = 0
      income_ratio = 0.8
      
      @trips.each do |trip|
        trip_minus_fee = trip.cost - 1.65
        if trip_minus_fee > 0
          total_revenue += (trip_minus_fee * income_ratio).round(2)
        else
          trip_minus_fee += total_revenue
        end
      end
      return total_revenue
    end
    
    private
    
    def self.from_csv(record)
      return self.new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end
