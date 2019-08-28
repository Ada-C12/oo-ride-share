require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
    def initialize (id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      
      @name = name
      @vin = vin
      raise ArgumentError, "Invalid VIN" if @vin.length != 17
      @status = status
      raise ArgumentError, "Invalid status" unless [:AVAILABLE, :UNAVAILABLE].include?(@status)
      @trips = trips || []
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def change_status_to_unavailable
      @status = :UNAVAILABLE
    end
    
    def average_rating
      return 0 if @trips == []
      
      completed_trips = @trips.select {|trip| trip.end_time != nil}
      
      total_rating = completed_trips.map {|trip| trip.rating}.sum.to_f
      
      return (total_rating/completed_trips.length)
    end
    
    def total_revenue
      return 0 if @trips == []
      
      total_revenue = 0.0
      
      completed_trips = @trips.select {|trip| trip.end_time != nil}
      
      # If trips are less than $1.65, no fee is applied for trip.
      completed_trips.each do |trip|
        total_revenue += trip.cost
        total_revenue -= 1.65 if trip.cost >= 1.65
      end
      
      return total_revenue *= 0.80
    end
    
    private
    
    def self.from_csv(record)
      #id,name,vin,status
      return self.new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end
