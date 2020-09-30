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

      rating_total = 0
      @trips.each do |trip|
        rating_total += trip.rating.to_f
      end

      trip_length = @trips.length

      average_rating = rating_total / trip_length
      return average_rating

      # @trips.reduce(0){ |total_time, trip| total_time + trip.duration}
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
