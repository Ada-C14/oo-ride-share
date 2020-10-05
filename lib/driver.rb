require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord

    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id: , name: , vin: , status: :AVAILABLE , trips: [])
      super(id)

      @name = name

      if vin.length == 17
        @vin = vin
      else
        raise ArgumentError, "The vin length =#{vin.length} need to equal 17"
      end

      @status = status

      @trips = trips

    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      sum = 0
      @trips.each do |trip|
        sum += trip.rating
      end
      if @trips.length == 0
        return 0
      else
        return (sum.to_f / @trips.length).round(2)
      end
    end

    def total_revenue
      driver_fee = 1.65
      total_earnings = 0

      @trips.each do |trip|

        if trip.cost < driver_fee
          trip_earnings = 0
        else
          trip_earnings = trip.cost - driver_fee
          trip_earnings = trip_earnings * 0.8
        end
        total_earnings += trip_earnings
      end

      return total_earnings.round(2)
    end


    def self.from_csv(record)
      return new(
          id: record[:id],
          name: record[:name],
          vin: record[:vin],
          status: record[:status],
      )
    end
  end
end