require 'csv'
require 'pry'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      if vin.length != 17
        raise ArgumentError.new("invalid vin")
      end

      unless [:AVAILABLE, :UNAVAILABLE].include?(status)
        raise ArgumentError.new("invalid status")
      end

      @name = name
      @vin = vin
      @status = status
      @trips = trips

    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return 0 if @trips.length == 0
      total_rating = @trips.sum { |trip| trip.rating }
      return (total_rating.to_f/@trips.length).round(1)
    end

    def total_revenue
      fee = 1.65
      drivers_cut = 0.8
      subtotal = 0

      @trips.each do |trip|
        if trip.cost <= fee
          subtotal += trip.cost * drivers_cut
        else
          subtotal += (trip.cost - fee) * drivers_cut
        end
      end

      return subtotal.round(2)
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
