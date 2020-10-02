require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: [])
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      return nil if @trips.empty?

      return @trips.reduce(0) { |total_cost, trip| total_cost + ( trip.cost || 0 ) } # if trip.cost is falsy, treat as 0
    end

    def total_time_spent
      return nil if @trips.empty?

      return @trips.reduce(0) { |total_time, trip| total_time + ( trip.duration_in_seconds || 0 ) } #if duration_in_seconds is falsy, treat as 0
    end

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
