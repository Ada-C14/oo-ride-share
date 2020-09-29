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

    # return the toal amount of money passenger has spent of their trips
    # td.passengers.first.trips.sum {|trip| trip.cost}
    def net_expenditures
      if @trips.empty?
        return "Passenger didn't take any trips"
      else
        return @trips.sum {|trip| trip.cost}
      end

    end

    # return the total amount of time spent has spent of their trips in secs?
    def total_time_spent
      if @trips.empty?
        return "Passenger didn't take any trips"
      else
        return @trips.sum {|trip| trip.trip_duration_in_secs}
      end

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
