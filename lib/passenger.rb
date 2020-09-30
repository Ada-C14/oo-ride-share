require_relative 'csv_record'
require 'time'
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
      total_money_spent_by_this_passenger = 0
      @trips.each do |trip|
        total_money_spent_by_this_passenger += trip.cost
      end
      return total_money_spent_by_this_passenger
    end

    def total_time_spent
      total_time_spent_by_this_passenger = 0
      @trips.each do |trip|
        total_time_spent_by_this_passenger += trip.duration
      end
      return total_time_spent_by_this_passenger
    end

    # def total_time_spent
    #   total_time_spent_by_this_passenger = 0
    #   if @trips == []
    #        total_time_spent_by_this_passenger = 0
    #   else
    #     time_arr = @trips.map{|trip|trip.duration}
    #     total_time_spent_by_this_passenger = (time_arr.sum).to_i
    #   end
    #   return total_time_spent_by_this_passenger
    #   end

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
