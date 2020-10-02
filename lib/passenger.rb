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
        total_cost = 0
      else
        completed_trips = @trips.select do |trip|
          trip.cost != nil
        end

        total_cost = completed_trips.sum do |trip|
          trip.cost
        end
      end

      return total_cost
    end

    def total_time_spent # return the total amount of time that passenger has spent on their trips
      if @trips.empty?
        total_time_spent = 0
      else
        completed_trips = @trips.select do |trip|
          trip.get_duration != nil
        end

        total_time_spent = completed_trips.sum do |trip|
          trip.get_duration
        end
      end

      return total_time_spent
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
