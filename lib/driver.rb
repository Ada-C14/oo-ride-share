require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [] )
      valid_driver_status = [:UNAVAILABLE , :AVAILABLE]

      super(id) #calling on the super class csv_record

      @name = name
      @vin = vin
      raise ArgumentError, 'String must be length 17' if vin.length != 17
      @status = status
      raise ArgumentError, 'Driver status must be available or unavailable' unless valid_driver_status.include?(status)
      @trips = trips

    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if trips.empty?
        average_rating = 0
      else
        total_ratings = trips.sum do |trip|
           trip.rating
        end
        average_rating = total_ratings.to_f/trips.length
      end
      return average_rating
    end

    def total_revenue
      total_revenue = 0.0

      if @trips.empty?
        return total_revenue
      else
        @trips.each do |trip|
          if trip.cost < 1.65
            total_revenue += trip.cost
          elsif trip.cost >= 1.65
            total_revenue += (0.80 * (trip.cost - 1.65))
          end
        end
      end

      return total_revenue.round(2)
    end

    private

    def self.from_csv(record) #one row in the csv file
      return new(
          id: record[:id],
          name: record[:name],
          vin: record[:vin],
          status: record[:status].to_sym
      )
    end
  end
end