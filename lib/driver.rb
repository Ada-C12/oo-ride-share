require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super (id)
      if vin.length != 17
        raise ArgumentError.new "Error! Vin must contain exactly 17 characters."
      end
      
      @name = name
      @vin = vin
      @status = status
      @trips = trips || []
      
    end

    def add_trip(trip)
      # puts "#{trip.class.name} at trip"
      @trips << trip
    end

    def average_rating
      if @trips.empty?
        return 0
      end

      ratings = @trips.map do |trip|
        trip.rating.to_f
      end
      avg_rating = ratings.sum / ratings.length
      return avg_rating
    end
    
    def total_revenue
      if @trips == []
        return 0
      else
        total = 0
        @trips.each do |trip|
          # puts trip.class.name
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