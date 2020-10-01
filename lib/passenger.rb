require_relative 'csv_record'
#require_relative 'trip'

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
      all_cost = @trips.map { |trip| trip.cost}
      return all_cost.compact.sum
    end

    def total_time_spent
      all_times = @trips.map {|trip| trip.duration}
      return all_times.compact.sum
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
