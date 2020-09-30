require_relative 'csv_record'

STATUSES = [:AVAILABLE, :UNAVAILABLE]

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips


    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      raise ArgumentError, 'Name must be a string' unless name.class == String
      @name = name
      raise ArgumentError, 'Incorrect VIN format' unless vin.length == 17 && vin.class == String
      @vin = vin
      raise ArgumentError, 'Incorrect status' unless STATUSES.include?(status)
      @status = status
      raise ArgumentError, 'Not an Array' unless trips.class == Array
      @trips = trips
    end

    def add_trip(trip)
      raise ArgumentError, 'Invalid trip' unless trip.class == Trip
      @trips << trip
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
