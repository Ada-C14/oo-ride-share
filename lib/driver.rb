require_relative 'csv_record'

STATUSES = [:AVAILABLE, :UNAVAILABLE]

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips


    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      raise ArgumentError.new('Name must be a string') unless name.class == String
      @name = name
      raise ArgumentError.new('Incorrect VIN format') unless vin.length == 17 && vin.class == String
      @vin = vin
      raise ArgumentError.new('Incorrect status') unless STATUSES.include?(status)
      @status = status
      raise ArgumentError.new('Not an Array') unless trips.class == Array
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
