require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      raise ArgumentError.new("Invalid VIN length") unless vin.length == 17
      raise ArgumentError.new("Invalid status") unless [:AVAILABLE, :UNAVAILABLE].include?(status.to_sym)

      super(id)

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      all_ratings = @trips.map { |trip| trip.rating }

      if all_ratings.length == 0
        return 0
      else
        average = all_ratings.compact.sum.to_f / all_ratings.compact.length
        return average
      end

    end

    def total_revenue
      all_cost = @trips.map do |trip|
        case trip.cost
        when nil
          nil
        when (0...1.65)
          0
        else
          (trip.cost - 1.65) * 0.8
        end
      end

      return all_cost.compact.sum
    end

    def make_unavailable
      @status = :UNAVAILABLE
    end

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
