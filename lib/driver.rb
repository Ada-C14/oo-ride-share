require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name

      unless vin.to_s.length == 17
        raise ArgumentError, "VIN must be a string of length 17"
      end
      @vin = vin

      @status = status
      @trips = trips

      availability = [:AVAILABLE, :UNAVAILABLE]
      unless availability.include?(@status)
        raise ArgumentError, "invalid driver availability"
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return 0 if @trips.empty?
      sum_of_ratings = @trips.sum { |trip| trip.rating }

      average = sum_of_ratings / @trips.length
      return average.to_f
    end

    def total_revenue
      return 0 if @trips.empty?

      total_cost = @trips.sum do |trip|
        if trip.cost <= 1.65
          trip.cost * 0.9
        else
          (trip.cost - 1.65) * 0.8
        end
      end

      return total_cost
    end

    def make_driver_unavailable
      @status = :UNAVAILABLE
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


