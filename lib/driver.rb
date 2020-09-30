require 'csv'

require_relative 'csv_record'

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

      @name = name
      @vin = vin
      @status = status
      @trips = trips

      super(id)

      raise ArgumentError.new("Invalid Status") unless [:AVAILABLE, :UNAVAILABLE].include?(status)

      raise ArgumentError if vin.length != 17
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