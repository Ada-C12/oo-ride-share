require_relative 'csv_record'
require 'pry'

module RideShare
    class Driver < CsvRecord
        attr_reader :name, :vin, :trips
        attr_accessor :status
        
        def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil )
            super(id)
            
            status_options = [:AVAILABLE, :UNAVAILABLE]
            if vin == nil || vin == ""
                raise ArgumentError.new "Driver has no vin"
            elsif vin.length > 17 
                raise ArgumentError.new "String is longer than 17" 
            end
            
            if status_options.include?(status)
                @status = status
            else                
                raise ArgumentError.new "Status is invalid"
            end
            
            @name = name
            @vin = vin
            @trips = trips || []
            
        end
        
        def add_trip(trip)
            @trips << trip
        end
        
        def total_revenue
            if @trips == nil || @trips == []
                return 0
            end
            costs = @trips.map do |trip|
                trip.cost
            end 
            if costs.sum < 1.65
                return 0
            end
            revenue = (costs.sum- 1.65) * 0.80
            return revenue.to_f
        end
        
        
        def average_rating
            if @trips == nil || @trips == []
                return 0
            end
            ratings = @trips.map do |trip|
                trip.rating
            end 
            return (ratings.sum/ratings.length).to_f
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



