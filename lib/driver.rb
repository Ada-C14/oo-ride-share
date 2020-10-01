require_relative 'csv_record'


module RideShare
  class Driver < CsvRecord
    VALID_STATUSES = [:AVAILABLE , :UNAVAILABLE]

    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status:, trips: [])
      super(id)

      validate_status(status)
      @name = name
      validate_vin(vin)
      @vin = vin
      @trips = trips
    end

    def validate_vin(vin)
      if vin.length != 17
        raise ArgumentError.new("Invalid vin. Must be 17 digits.")
      end
    end

    def validate_status(status)
      if VALID_STATUSES.include?(status)
        @status = status
      else
        raise ArgumentError.new("Invalid status.")
      end
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