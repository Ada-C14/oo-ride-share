require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status , :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      raise ArgumentError.new("The vin length:#{vin.length} is INVALID") if vin.length != 17
      @name = name
      @vin = vin
      @trips = trips
      list_of_status = [:AVAILABLE, :UNAVAILABLE]
      if list_of_status.include? status
        @status = status
      else
        raise ArgumentError, "This is a invalid status"
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if trips.length == 0
        return 0
      end

      sum = @trips.sum {|trip| trip.rating}
      average = sum / trips.length.to_f
      average.round(1)
    end

    def total_revenue
      sum = @trips.sum {|trip| trip.cost}
      fee = 1.65 * trips.count
      return 0.8 * sum - fee

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