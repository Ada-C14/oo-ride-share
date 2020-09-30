require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    def initialize(id:, name:, vin:, status:, trips: [])
      super(id)
      @name = name
      raise ArgumentError if vin.length != 17
      @vin = vin
      valid_status = [:UNAVAILABLE, :AVAILABLE]
      unless valid_status.include?(status)
        raise ArgumentError("Must have valid status")
      end
      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      total = 0
      @trips.each do |trip|
        total += trip.rating.to_f
      end
      average_total = total/@trips.length
      return average_total
    end

    def total_revenue
      revenue = 0
      @trips.each do |trip|
        revenue += @trips.cost.to_f
      end
      return revenue
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