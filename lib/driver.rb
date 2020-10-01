require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    VALID_STATUSES = [:AVAILABLE , :UNAVAILABLE]

    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status:, trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips
    end

    def validate_status(status)
      if !VALID_STATUSES.include? status
        raise ArgumentError.new ("Invalid status.")
      end
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