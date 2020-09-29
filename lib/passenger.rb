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
      if @trips.empty?
        raise ArgumentError, 'This passenger has no trips'
      else
        return (@trips.map {|trip| trip.cost}).sum
      end
    end

    def total_time_spent
      if @trips.empty?
        raise ArgumentError, 'This passenger has no trips'
      else
        return (@trips.map {|trip| trip.duration}).sum
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

