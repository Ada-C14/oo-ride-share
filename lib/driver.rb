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