require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      raise ArgumentError.new("Invalid VIN length") unless vin.length == 17
      raise ArgumentError.new("Invalid status") unless [:AVAILABLE, :UNAVAILABLE].include?(status)

      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips
    end
  end
end