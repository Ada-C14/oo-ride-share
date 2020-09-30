require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name.to_s
      @vin = vin.to_s
      @status = status.to_sym
      @trips = trips

      raise ArgumentError, 'Invalid vin number' if vin.length != 17
      raise ArgumentError, 'Invalid status' unless [:AVAILABLE, :UNAVAILABLE].include? status.to_sym

    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips.empty?
        return 0
      else
        if @trips.last.end_time == nil
          raise ArgumentError, 'Wait! There is a trip in progress. Please try again later.'
        else
          total_rating = (@trips.map {|trip| trip.rating}).sum
          return (total_rating.to_f / @trips.length).round(1)
        end
      end
    end

    def total_revenue
      if @trips.empty?
        return 0
      else
        total_cost = @trips.map do |trip|
          if trip.cost > 1.65
            (trip.cost - 1.65).to_f
          else
            raise ArgumentError, 'The trip cost is less than the Trip fee'
          end
        end
        total_rev = total_cost.sum
        return (total_rev * 0.80).round(2)
      end
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

