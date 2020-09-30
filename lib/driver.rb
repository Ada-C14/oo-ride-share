# frozen_string_literal: true

require_relative 'trip_dispatcher'
require_relative 'csv_record'

#require 'csv'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips

      raise ArgumentError, "Bad Vin Number" unless vin.length == 17
      #raise for vin string length
      # raise error for bad ID
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return 0 if @trips.empty?

      total_ratings = @trips.reduce(0){ |ratings_total, trip| ratings_total + trip.rating.to_f}
      trip_length = @trips.length
      average_rating = total_ratings / trip_length

      return average_rating
    end

    def fee_charge_on_trip_cost(trip_cost)
      if trip_cost < 1.65
        return trip_cost
      else
        return trip_cost - 1.65
      end
    end

    def total_revenue
      return 0 if @trips.empty?
      return @trips.reduce(0){ |total_revenue, trip| total_revenue + (fee_charge_on_trip_cost(trip.cost.to_f) * 0.8) }
    end

    private
    def self.from_csv(record)
      new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end

  end
end
