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
      return 0 if trips.length == 0
      sum = @trips.sum {|trip| trip.rating}
      average = sum / trips.length.to_f
      average.round(1)
    end

    def total_revenue
      return 0 if trips.length == 0
      sum = @trips.sum {|trip| trip.cost}

      # we decided that the rider wouldn't get any money if the cost of the trip was less than 1.65
      return 0 if sum < 1.65
      fee = 1.65 * trips.count
      return 0.8 * sum - fee
    end

    def request_trip_helper(new_trip)
      add_trip(new_trip)
      @status = :UNAVAILABLE
      new_trip.passenger.add_trip(new_trip)
    end

    def get_latest_trip
      return @trips.max_by {|trip| trip.end_time}
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