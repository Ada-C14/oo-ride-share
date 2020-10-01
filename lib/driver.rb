require 'csv'
require_relative 'csv_record'

VALID_STATUS = [:AVAILABLE, :UNAVAILABLE]

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

      super(id)
      @name = name
      @vin = vin
      @status = status
      @trips = trips

      unless @vin.length == 17
        raise ArgumentError, "Invalid vehicle identification number"
      end

      raise ArgumentError, "Invalid driver status" if !VALID_STATUS.include?(@status)
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return 0 if @trips.empty?

      return @trips.reduce(0) { |average_rating, trip| average_rating + trip.rating }.to_f / @trips.length
    end

    def total_revenue
      return 0 if @trips.length == 0

      cost = @trips.reduce(0) { |total_cost, trip| total_cost + trip.cost }.to_f

      return 0 if cost < 1.65

      fee = @trips.length * 1.65
      return (cost - fee) * 0.8
    end

    def start_trip(trip)
      raise ArgumentError, "Driver status is UNAVAILABLE. Cannot start a new trip." if @status == :UNAVAILABLE

      @status = :UNAVAILABLE

      self.add_trip(trip)
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