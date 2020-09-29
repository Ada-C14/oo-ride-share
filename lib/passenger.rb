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
      total_cost = @trips.sum do |trip|
        trip.cost
      end
      return total_cost
    end

    def total_time_spent # return the total amount of time that passenger has spent on their trips
      total_time = @trips.sum do |trip|
        trip.get_duration
      end

      return total_time
    end

    private

    def self.from_csv(record) #one row in the csv file
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
