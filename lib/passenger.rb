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
    # method the return total amount of money passenger has spent on a trips
    def net_expenditures
      total_amount = @trip.sum { |trip| trip.cost }
      return total_amount
    end

    # method that Return the total amount of time passenger spent on a trips
    def total_time_spent
      # trip_duration method created in trip class
      total_time = @trip.sum { |trip| trip.trip_duration }
      return total_time
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
