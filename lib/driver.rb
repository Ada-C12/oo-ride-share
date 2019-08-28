require_relative 'csv_record'
require 'pry'

module RideShare
    class Driver < CsvRecord
        attr_reader :name, :vin, :status, :trips
        
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
        
        private
        
        def self.from_csv(record)
            return new(
                id: record[:id],
                name: record[:name],
                vin: record[:vin],
                status: record[:status],
            )
        end
    end
    
    
    
    
end



