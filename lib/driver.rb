require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader  :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name

      raise ArgumentError.new("invalid vin #{@vin}") if vin.length != 17
      @vin = vin

      raise ArgumentError.new("invalid status #{@status}") unless [:AVAILABLE, :UNAVAILABLE].include?(status.to_sym)
      @status = status.to_sym

      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips.empty?
        return 0
      else
        total_rating = @trips.sum { |trip| trip.rating }
        average = (total_rating / @trips.length).to_f
        return average
      end
    end

    def total_revenue
      commission = 0.8
      fee = 1.65
      return 0 if @trips.empty?

      revenue = @trips.sum do |trip|
        if trip.cost < 1.65
          return 0
        else
          trip.cost * commission - fee
        end
      end
      return revenue.round(2)
    end

    private


    def self.from_csv(record)
      return self.new(
          id: record[:id],
          name: record[:name],
          vin: record[:vin],
          status: record[:status]
      )
    end
  end
end