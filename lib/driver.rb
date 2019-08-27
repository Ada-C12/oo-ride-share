require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    
    attr_reader :name, :vin, :status, :trips
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      
      @name = name
      
      if !(vin.length == 17)
        raise ArgumentError.new("VIN is improper length")
      else
        @vin = vin
      end
      
      status_options = [:AVAILABLE, :UNAVAILABLE]
      if !(status_options.include?(status))
        raise ArgumentError.new("Inappropriate status")
      else
        @status = status
      end
      
      @trips = trips || []
    end
    
    private
    
    def self.from_csv(record)
      return self.new(
        id: record[:id].to_i,
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
    
    # def self.from_csv(record)
    #   start_time = Time.parse(record[:start_time])
    #   end_time = Time.parse(record[:end_time])
    
    #   return self.new(
    #     id: record[:id],
    #     passenger_id: record[:passenger_id],
    #     start_time: start_time,
    #     end_time: end_time,
    #     cost: record[:cost],
    #     rating: record[:rating]
    #   )
    # end
    
    # def self.from_csv(record)
    #   return new(
    #     id: record[:id],
    #     name: record[:name],
    #     phone_number: record[:phone_num]
    #   )
    # end
    
  end
end
