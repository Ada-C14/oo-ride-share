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
      all_cost = @trips.map { |trip| trip.cost }

      all_cost.nil? ? 0 : all_cost.sum
    end

    def total_time_spent
      all_times = @trips.map {|trip| trip.duration}

      all_times.nil? ? 0 : all_times.sum
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
