require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      raise ArgumentError.new("Invalid VIN length") unless vin.length == 17
      raise ArgumentError.new("Invalid status") unless [:AVAILABLE, :UNAVAILABLE].include?(status.to_sym)

      super(id)

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips
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