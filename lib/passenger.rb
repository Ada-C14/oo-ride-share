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

    # returns 0 for empty trip array
    def net_expenditures
      if @trips.empty?
        0
      else
        @trips.inject(0) do |total_cost, trip|
          if trip.cost.nil?
            total_cost
          else
            total_cost + trip.cost
          end
        end
      end
    end

    # returns 0 for empty trip array
    def total_time_spent
      # @trips.empty? ? 0 : @trips.inject(0) { |total_time, trip| total_time + trip.trip_duration }
      if @trips.empty?
        0
      else
        @trips.inject(0) do |total_time, trip|
          begin
            trip.trip_duration
          rescue ArgumentError
            next total_time
          end
          total_time + trip.trip_duration
        end
      end
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
