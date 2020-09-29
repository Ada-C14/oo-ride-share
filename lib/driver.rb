require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, vin:, status:, trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips

      raise ArgumentError, 'Invalid vin number' if vin.length != 17
      raise ArgumentError, 'Invalid status' unless [:AVAILABLE, :UNAVAILABLE].include? status

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

