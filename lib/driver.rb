require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super (id)
      if vin.length != 17
        raise ArgumentError.new "Error! Vin must contain exactly 17 characters."
      end
      
      valid_statuses = [:AVAILABLE, :UNAVAILABLE]
      if !valid_statuses.include?(status.to_sym)
        raise ArgumentError.new "Error! The status you entered is invalid."
      end
      
      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips || []
      
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def add_in_progress_trip(trip)
      trip.driver.status = :UNAVAILABLE
      @trips << trip
    end
    
    def ignore_incomplete_trips(trips)
      if trips.empty?
        return []
      end
      copy_of_trips = trips.dup
      copy_of_trips.delete_if do |trip|
        trip.end_time == nil
      end
      return copy_of_trips
    end
    
    def average_rating
      valid_trips = ignore_incomplete_trips(@trips)
      if valid_trips.empty?
        return 0
      end
      
      ratings = valid_trips.map do |trip|
        trip.rating.to_f
      end
      avg_rating = ratings.sum / ratings.length
      return avg_rating
    end
    
    def total_revenue
      valid_trips = ignore_incomplete_trips(@trips)
      if valid_trips == []
        return 0
      else
        total = 0
        valid_trips.each do |trip|
          if trip.cost < 1.65
          else
            total += ((trip.cost - 1.65) * 0.8)
          end
        end
        return total
      end
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