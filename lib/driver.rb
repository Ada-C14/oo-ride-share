require 'csv'
require 'time'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(
        id:,
        name:,
        vin:,
        status:,
        trips: []
    )
      super(id)

      raise ArgumentError, 'Length of vin must be 17' unless vin.to_s.length == 17

      status_array = [:AVAILABLE, :UNAVAILABLE]
      # status_array = %i[ AVAILABLE UNAVAILABLE] same as above
      raise ArgumentError, 'Status must be :AVAILABLE or :UNAVAILABLE' unless status_array.include?(status.to_sym)

      @name = name
      @vin = vin
      @status = status
      @trips = trips
    end

    # THREE METHODS -------------- DONT FORGET TO ADD TESTTTTTTTTTTTTTTTTTTTTTTTTTTTSSSSSSSSSSSSSSSSS
    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips == []
        return nil
      else
        sum_of_ratings = 0.0
      @trips.each do |trip|
        sum_of_ratings += trip.rating
      end
      number_of_ratings = @trips.length
      return sum_of_ratings / number_of_ratings
      end
    end

    def total_revenue
      total = 0.0
      @trips.each do |trip|
        if trip.cost > 1.65
        total += (trip.cost - 1.65)*0.80
        end
      end
      return total
    end

    private
    def self.from_csv(record)
      return self.new(
          id: record[:id].to_i,
          name: record[:name],
          vin: record[:vin],
          status: record[:status]
       )
    end
  end
end



