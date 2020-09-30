require 'csv'

require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      @name = name
      if vin.length != 17
        raise ArgumentError, 'Invalid VIN number'
      end
      
      @vin = vin
      if status != :AVAILABLE && status != :UNAVAILABLE
        raise ArgumentError, "Invalid status#{status}"
      end

      @status = status
      
      @trips = trips
    end

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