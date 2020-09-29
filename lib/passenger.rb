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
      all_trip_cost = 0.00
       @trips.map { |trip| all_trip_cost += trip.cost.to_f }
      return all_trip_cost
    end

    def total_time_spent
      all_time_spent = 0.00
      @trips.map { |trip| all_time_spent += trip.duration}
      return all_time_spent
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
