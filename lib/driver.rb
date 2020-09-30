require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name

      raise ArgumentError.new("Invalid VIN: #{ vin }") if vin.length != 17
      @vin = vin

      raise ArgumentError.new("Invalid status: #{ status }") unless [:AVAILABLE, :UNAVAILABLE].include? (status.to_sym)
      @status = status.to_sym

      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end


    def average_rating
      return 0 if @trips.length == 0

      total = @trips.sum { |trip| trip.rating }
      average = total.to_f / @trips.length
      return average
    end

    def total_revenue
      return 0 if @trips.length == 0

      total = @trips.sum do |trip|
        if trip.cost < 1.65
          fee = 0
        else
          fee = 1.65
        end
      ((trip.cost - fee) * 0.8)
      end
      return total.round(2)
    end

    def trip_in_progress
      @status = :UNAVAILABLE
    end

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end
  end
end