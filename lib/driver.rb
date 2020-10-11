require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name

      raise ArgumentError.new("Invalid VIN: #{ vin }") if vin.length != 17
      @vin = vin

      raise ArgumentError.new("Invalid status: #{ status }") unless [:AVAILABLE, :UNAVAILABLE].include? (status.to_sym)
      @status = status.to_sym

      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      length = @trips.length
      return 0 if length == 0

      total = 0

      @trips.each do |trip|
        total += trip.rating unless trip.rating.nil?
          if trip.rating.nil?
            length -= 1
          end
        end
      average = total.to_f / length
      return average.round(1)
    end

    def total_revenue
      return 0 if @trips.length == 0

      total = 0

      @trips.each do |trip|
        if trip.cost.nil?
          next
        elsif trip.cost <= 1.65
          total += (trip.cost * 0.8)
        elsif
          total += ((trip.cost - 1.65) * 0.8)
        end
      end
      return total.round(2)
    end

    def trip_in_progress
      @status = :UNAVAILABLE
    end

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end
  end
end