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
      @status = status
      @trips = trips

      raise ArgumentError, "Bad Vin Number" unless vin.length == 17
      #raise for vin string length
      # raise error for bad ID
    end

    def add_trip(trip)
      @trips << trip
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
