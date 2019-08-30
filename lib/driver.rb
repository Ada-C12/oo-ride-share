require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

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
        raise ArgumentError.new('Invalid status')
      end 
    end 

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      ratings = []
      @trips.each do |trip|
        if trip.rating != nil
          ratings << trip.rating
        end
      end
      if ratings.length > 0
        ratings_total = ratings.sum
        avg_rating = ((ratings_total + 0.0) / ratings.length)
      else
        return 0
      end
      return avg_rating
    end

    def total_revenue
      revenue_per_trip = []
      @trips.each do |trip|
        if trip.cost != nil
          revenue_per_trip << (trip.cost - 1.65)*0.8
        end
      end  

      if revenue_per_trip.length > 0
        total_revenue = revenue_per_trip.sum
      else
        return 0
      end
      return total_revenue
    end

    #adds new trip and changes the driver status from available to unavailable
    def add_new_trip(trip)
      self.status = :UNAVAILABLE
      add_trip(trip)
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
