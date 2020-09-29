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

    # def net_expenditures
    #   all_trip_cost = 0.00
    #   @trips.map { |trip| all_trip_cost += trip.cost.to_f }
    #   return all_trip_cost
    # end
    #
    # def total_time_spent
    #   all_time_spent = 0.00
    #   @trips.map { |trip| all_time_spent += trip.duration}
    #   return all_time_spent
    # end

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

