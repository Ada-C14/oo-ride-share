require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name

      raise ArgumentError, "VIN must be 17 characters long." if vin.length != 17
      @vin = vin

      if %i[AVAILABLE UNAVAILABLE].include?(status)
        @status = status
      else
        raise ArgumentError, "Invalid status. Must be AVAILABLE or UNAVAILABLE."
      end

      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return 0 if @trips.empty?

      valid_ratings = @trips.select { |trip| ! trip.rating.nil? }
      ratings_sum = valid_ratings.sum(0.0) { |trip| trip.rating }

      return (ratings_sum / valid_ratings.length).round(1)
    end

    def total_revenue
      return 0 if @trips.empty?

      sum_revenue = @trips.select.sum { |trip| ! trip.cost.nil? && trip.cost > 1.65 ? 0.8 * (trip.cost - 1.65) : 0 }

      return sum_revenue.round(2)
    end

    def change_status
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