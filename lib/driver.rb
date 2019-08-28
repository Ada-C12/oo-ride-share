require_relative 'csv_record'

module RideShare
    class Driver < CsvRecord
        attr_reader id:, name:, vin:, status:, trips:
        
        def initialize(id:, name:, vin:, status:, trips: nil )
            super(id)
            
            if vin.length > 17 
                raise ArgumentError.new "String is longer than 17"
            elsif status != :AVAILABLE || status != :UNAVAILABLE
                raise ArgumentError.new "Status is invalid"
            end
            
            @name = name
            @vin = vin
            @status = status
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

end


