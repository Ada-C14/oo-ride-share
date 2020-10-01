require_relative 'csv_record'

STATUSES = [:AVAILABLE, :UNAVAILABLE]

module RideShare
  class Driver < CsvRecord

    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      raise ArgumentError, 'Name must be a string' unless name.class == String
      @name = name
      raise ArgumentError, 'Incorrect VIN format' unless vin.length == 17 && vin.class == String
      @vin = vin
      raise ArgumentError, 'Incorrect status' unless STATUSES.include?(status)
      @status = status
      raise ArgumentError, 'Not an Array' unless trips.class == Array
      @trips = trips
    end

    def add_trip(trip)
      raise ArgumentError, 'Invalid trip' unless trip.class == Trip
      @trips << trip
    end

    def take_trip(trip)
      raise ArgumentError, 'Invalid trip' unless trip.class == Trip
      @trips << trip
      @status = :UNAVAILABLE
    end

    def average_rating
      return 0 if @trips.empty?

      total_rating = 0
      rated_trips = 0
      @trips.each do |trip|
        next if trip.rating.nil?
        total_rating += trip.rating
        rated_trips += 1
      end

      avg_rating = total_rating / rated_trips.to_f
      return avg_rating
    end

    def total_revenue
      return 0 if @trips.empty?

      total_earnings = 0
      @trips.each do |trip|
        if trip.cost.nil?
          next
        elsif trip.cost <= 1.65
          total_earnings += 0.8 * trip.cost
        else
          total_earnings += 0.8 * (trip.cost - 1.65)
        end
      end

      return total_earnings.floor(2)
    end

    private

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
