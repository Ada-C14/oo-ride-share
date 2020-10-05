require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: [])
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips
    end

    def add_trip(trip)
      raise ArgumentError, 'Invalid trip' unless trip.class == Trip
      @trips << trip
    end

    def net_expenditures
      return 0 if @trips.empty?

      total_expenditure = 0
      @trips.each do |trip|
        total_expenditure += trip.cost unless trip.cost.nil?
      end

      return total_expenditure
    end

    def total_time_spent
      return 0 if @trips.empty?
      total_time_spent = 0
      @trips.each do |trip|
        unless trip.start_time.nil? || trip.end_time.nil?
          total_time_spent += (trip.end_time - trip.start_time)
        end
      end

      return total_time_spent
    end

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end