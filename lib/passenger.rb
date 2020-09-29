# frozen_string_literal: true

require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: [])
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    # returns nil for empty trip array
    def net_expenditures
      # ternary operator + use of inject enumerable
      @trips.empty? ? nil : @trips.inject(0) { |total_cost, trip| total_cost + trip.cost }
    end

    # returns nil for empty trip array
    def total_time_spent
      @trips.empty? ? nil : @trips.inject(0) { |total_time, trip| total_time + trip.trip_duration }
    end

    def self.from_csv(record)
      new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
