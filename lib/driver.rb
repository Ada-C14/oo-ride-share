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