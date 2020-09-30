require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    STATUS = [:UNAVAILABLE, :AVAILABLE]

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      raise ArgumentError.new("Invalid vin #{vin}") if vin.length != 17
      raise ArgumentError.new("Invalid status #{status}") unless STATUS.include?(status)

      @name = name
      @vin = vin
      @status = status
      @trips = trips
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      sum_of_ratings = 0.00
      average = 0.00
      if @trips.empty?
        return average
      else
        @trips.map { |trip| sum_of_ratings += trip.rating.to_f }
        average = (sum_of_ratings/@trips.length).to_f.round(2)
      end
        return average
    end

    def total_revenue
      revenue = 0.00
      return 0.00 if @trips.empty?
      @trips.each do |trip|
        if trip.cost < 1.65
          next
        else
          revenue += ((trip.cost - 1.65)*0.8)
        end
      end
      return revenue
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

