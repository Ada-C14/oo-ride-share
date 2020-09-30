# frozen_string_literal: true
require_relative 'csv_record'
# This is a class for the driver object
module RideShare
  class Driver < CsvRecord
    # generic readers
    attr_reader :name, :vin, :status, :trips
    # constructor
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      raise ArgumentError, 'Invalid VIN entry. Must be 17 characters in length' if vin.length != 17
      raise ArgumentError, "Invalid STATUS entry. Must be one of :AVAILABLE or :UNAVAILABLE" if status != :AVAILABLE && status != :UNAVAILABLE
      @name = name
      @vin = vin
      @status = status
      @trips = trips
    end
    # readers

    # writers
    def add_trip(trip)
      @trips << trip
    end

    # class methods
    def self.from_csv(record)
      new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end
