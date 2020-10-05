# frozen_string_literal: true

require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name

      raise ArgumentError, 'Invalid VIN number' if vin.length != 17

      @vin = vin

      raise ArgumentError, "Invalid status#{status}" if status != :AVAILABLE && status != :UNAVAILABLE

      @status = status

      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      total_rating = 0
      @trips.each do |trip|
        total_rating += trip.rating unless trip.end_time.nil?
      end

      completed_trips = @trips.count(&:end_time) # count truthy values
      average_rating = total_rating.to_f / completed_trips

      if @trips.length.zero?
        return 0
      else
        return average_rating.round(2)
      end

    end

    def total_revenue
      total = 0
      fee_per_trip = 1.65
      earning_rate = 0.8

      @trips.each do |trip|
        total += trip.cost - fee_per_trip unless trip.end_time.nil?
      end
      earning = total * earning_rate
      if earning.negative?
        return 0
      else
        return earning.round(2)
      end

    end

    def trip_status_updating(trip)
      @trips << trip
      @status = :UNAVAILABLE if trip.end_time.nil?
    end

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