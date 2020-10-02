require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips, :status

    def initialize(id:, name:, vin:, trips: [], status: :AVAILABLE)
      super(id)

      @name = name
      @vin = vin
      @trips = trips
      @status = status.to_sym

      check_status(status)
      check_vin(vin)
    end

    def check_vin(vin)
      if vin.length < 17 || vin.length > 17
        raise ArgumentError.new("Invalid vin")
      end
    end

    def check_status(status)
      valid_status = [:AVAILABLE, :UNAVAILABLE]
      if valid_status.include?(status.to_sym) == false
        raise ArgumentError.new("Invalid status")
      else
        return true
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips == []
        return 0
      end

      rating = 0
      @trips.each do |trip|
        rating += trip.rating
      end
      total_rating = rating.to_f / @trips.length
      return total_rating
    end


    def total_revenue
      if @trips == []
        return 0
      end

      revenue = 0
      @trips.each do |trip|
        cost = (trip.cost - 1.65) * 0.8
        revenue += cost
      end
      return revenue
    end

    def start_trip(trip)
      @status = :UNAVAILABLE
      @trips << trip
    end

    private

    def self.from_csv(record) #Child class
      return new(
          id: record[:id],
          name: record[:name],
          vin: record[:vin],
          status: record[:status]
      )
    end
  end
end

