require_relative 'csv_record'
require_relative 'trip'
require_relative 'passenger'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name
      @vin = vin

      raise ArgumentError.new("Invalid status") if (vin.length) != 17

      @status = status
      raise ArgumentError, "Invalid status" if ![:AVAILABLE, :UNAVAILABLE].include?(@status)

      @trips = trips

    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      ratings_array = @trips.map(&:rating)
      return 0 if (@trips) == [] || @trips == nil
      return (ratings_array.sum/ratings_array.length).to_f
    end

    def total_revenue
      return 0 if (@trips) == [] || @trips == nil
      trip_cost = @trips.map(&:cost)
      return 0 if trip_cost.sum < 1.65
      driver_revenue = (trip_cost.sum - 1.65) * 0.80
      return driver_revenue.to_f
    end
    #
    #
    # def net_expenditures
    #   total_expenditure = @trips.sum(&:cost)
    #   return total_expenditure
    # end
    #
    # def total_time_spent
    #   return @trips.sum(&:duration_trip)
    # end

    private

    def self.from_csv(record)
      return new(
          id: record[:id],
          name: record[:name],
          vin: record[:vin],
          status: record[:status]
      )
    end
  end
end
