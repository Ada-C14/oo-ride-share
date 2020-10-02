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

    # def net_expenditures
    #   if @trips.empty?
    #     return "this passenger took no trips"
    #   end
    #
    #   array = []
    #   @trips.each do |trip|
    #     array << trip.cost
    #   end
    #   return array.sum
    #
    # end

    # return the toal amount of money passenger has spent of their trips
    # td.passengers.first.trips.sum {|trip| trip.cost}
    def net_expenditures
      # need to account when cost is nil for in-progress trips
      # sum = 0
      # if @trips.empty?
      #   return 0
      # else
      #   @trips.each do |trip|
      #     if trip.cost == nil
      #       sum += 0
      #     else
      #       sum += trip.cost
      #     end
      #   end
      # end
      #
      # return sum

      # if @trips.empty?
      #   return 0
      # else
      #   @trips.sum do |trip|
      #     if !(trip.end_time == nil )
      #       trip.cost
      #     end
      #   end
      # end

      # @trips.sum do |trip|
      #   if !(trip.end_time == nil )
      #     trip.cost
      #   end
      # end

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
      #need to account is end_time in nil for in-progress trups
      # if @trips.empty?
      #   return 0
      # else
      #   return @trips.sum {|trip| trip.duration}
      # end

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





    # return the total amount of time spent has spent of their trips in secs?
    # def total_time_spent
    #   if @trips.empty?
    #     return "Passenger didn't take any trips"
    #   else
    #     return @trips.sum {|trip| trip.trip_duration_in_secs}
    #   end
    #
    # end

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
