require 'csv'
require 'time'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

    def initialize(
        id:,
        name:,
        vin:,
        status: :AVAILABLE,
        trips: []
    )

      @status = status.to_sym
      super(id)

      raise ArgumentError, 'Length of vin must be 17' unless vin.to_s.length == 17

      status_array = [:AVAILABLE, :UNAVAILABLE]
      # status_array = %i[ AVAILABLE UNAVAILABLE] same as above
      raise ArgumentError, 'Status must be :AVAILABLE or :UNAVAILABLE' unless status_array.include?(status.to_sym)

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips == []
        return 0
      else
        sum_of_ratings = 0.00
        number_of_ratings = 0
      @trips.each do |trip|
        sum_of_ratings += trip.rating
        number_of_ratings += 1 unless trip.rating == 0
      end
        average = sum_of_ratings / number_of_ratings
      return average.round(2)
      end
    end

    def total_revenue
      total = 0.00
      @trips.each do |trip|
        if trip.cost > 1.65
        total += (trip.cost - 1.65)*0.80
        end
      end
      return total
    end

    #CHANGING THE DRIVER'S STATUS TO UNAVAILABLE
    def accept_trip_request(trip)
    @trips << trip
    self.status = :UNAVAILABLE
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



