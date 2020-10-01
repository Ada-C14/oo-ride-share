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

    def net_expenditures #will break for in progress trips "in progress trip - cost not available"
      return nil if @trips.empty?
      @trips.reduce(0) {|total, trip| total + trip.cost}
    end

    def total_time_spent  #will break for in progress trips - s/b error "in progress trip - duration not available"
      return 0 if @trips.empty?
      @trips.reduce(0){ |total_time, trip| total_time + trip.duration}
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
