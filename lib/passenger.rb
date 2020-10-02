require_relative 'csv_record'
require_relative 'trip'

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
      passenger_total_spent = 0

      if @trips == []
        raise ArgumentError.new("Passenger has 0 trips")
      end

      @trips.each do |trip|
        passenger_total_spent += trip.cost
      end
      return passenger_total_spent
    end

    def total_time_spent
      time = 0

      if @trips == []
        raise ArgumentError.new("Passenger has 0 trips")
      end

      @trips.each do |trip|
        trip_time =  trip.calculate_trip_duration
        time += trip_time
      end
      return time
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
