require 'csv'

require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      @name = name
      if vin.length != 17
        raise ArgumentError, 'Invalid VIN number'
      end

      @vin = vin
      if status != :AVAILABLE && status != :UNAVAILABLE
        raise ArgumentError, "Invalid status#{status}"
      end

      @status = status

      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      total_rating = 0
      @trips.each do |trip|
        total_rating += trip.rating
      end
      average_rating = total_rating.to_f / @trips.length
      if @trips.length == 0
        return 0
      else
        return average_rating.round(2)
      end
    end

    def total_revenue
      total = 0
      fee = 1.65

      @trips.each do |trip|
        total += trip.cost
      end

      earning = (total - fee) * 0.8
      if earning < 0
        return 0
      end

      return earning.round(2)

    end

    def driver_status_updating
      @trips.each do |trip|
        if trip.end_time == nil
          @status = :UNAVAILABLE
        end
      end
    end

    
    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end

  end
end