require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader  :name, :vin, status, trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name

      raise ArgumentError.new("invalid vin #{ vin }") if vin.length != 17
      @vin = vin

      raise ArgumentError.new("invalid status #{ status }") unless [:AVAILABLE, :UNAVAILABLE].include?(status.to_sym)
      @status = status.to_sym

      @trips = trips
    end
  end
end