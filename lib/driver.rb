require 'csv'

require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(
        id:,
        name:,
        vin:,
        status: :AVAILABLE,
        trips: []
    )

      @name = name
      @vin = vin
      @status = status
      @trips = trips

      super(id)

      raise ArgumentError.new("Invalid Status") unless [:AVAILABLE, :UNAVAILABLE].include?(status)

      raise ArgumentError if vin.length != 17
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return 0 if trips.empty?

      rating_sum = trips.inject(0) { |sum, trip| sum + trip.rating }
      num_ratings = trips.length
      average = (rating_sum/num_ratings.to_f).round(1)
      return average
    end

    def total_revenue
      return 0 if trips.empty?

      net_fee = trips.inject(0) do |sum, trip|
        if trip.cost <= 1.65
          sum + 0
        else
          sum + trip.cost - 1.65
        end
      end

      return (net_fee * 0.8).round(2)
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