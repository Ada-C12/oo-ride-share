require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips
      accepted_vin_length = 17
      if @vin.length != accepted_vin_length
        raise ArgumentError.new("Invalid VIN Length")
      end

      accepted_statuses = [:UNAVAILABLE, :AVAILABLE]
      if !accepted_statuses.include? @status
        raise ArgumentError.new("Invalid Status Input")
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      ratings_summed = 0
      @trips.each do |trip|
        ratings_summed += trip.rating
      end
      if @trips.length == 0
        return 0
      end
      average_rating = ratings_summed / @trips.length
      return average_rating.to_f
    end

    # This method calculates that driver's total revenue
    # across all their trips. Each driver gets 80% of the
    #  trip cost after a fee of $1.65 per trip is subtracted.
    def total_revenue
      total = 0
      dollars_for_the_man = 1.65

      @trips.each do |trip|
        if trip.cost > dollars_for_the_man
          puts trip.cost
          total += (trip.cost - dollars_for_the_man)
        end
      end

      total = total * 0.80
      return total.round(2)
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id].to_i,
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
             )
    end
  end
end
