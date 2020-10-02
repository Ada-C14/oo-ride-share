# frozen_string_literal: true

require_relative 'trip_dispatcher'
require_relative 'csv_record'

# require 'csv'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips

      raise ArgumentError, 'Bad Vin Number' unless vin.length == 17
      # raise for vin string length
      # raise error for bad ID
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating #if the driver has a trip in progress, it will skip that trip instance, and still return the average for only the trips that have a rating.  IF a passenger does not enter a rating (rating stays nil), the average is not affected.
      return 0 if @trips.empty?

      in_progress_trip = 0
      total_ratings = @trips.reduce(0) do |ratings_total, trip|
        if trip.rating.nil?
          in_progress_trip += 1
          next
        else
          ratings_total + trip.rating.to_f
        end
      end
      trip_length = @trips.length
      average_rating = total_ratings / (trip_length - in_progress_trip)

      return average_rating
    end

    def fee_charge_on_trip_cost(trip)
      if trip.cost.to_f < 1.65
        trip.cost.to_f
      else
        (trip.cost.to_f - 1.65)
      end
    end

    def total_revenue
      return 0 if @trips.empty?

      @trips.reduce(0) { |total_revenue, trip| total_revenue + (fee_charge_on_trip_cost(trip) * 0.8) }
    end

    def make_unavailable
      @status = :UNAVAILABLE
    end

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
