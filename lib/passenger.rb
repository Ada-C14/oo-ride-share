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
      # need to account when cost is nil for in-progress trips
      total_cost = 0

      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          if trip.end_time == nil
            total_cost += 0
          else
            total_cost += trip.cost
          end
        end
      end

      return total_cost

    end

    def total_time_spent
      #need to account is end_time in nil for in-progress trips
      total_time = 0

      @trips.each do |trip|
        if trip.end_time == nil
          total_time += 0
        else
          total_time += trip.duration
        end
      end

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
