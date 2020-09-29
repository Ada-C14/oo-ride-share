require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name.to_s
      @vin = vin.to_s
      @status = status.to_sym
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

