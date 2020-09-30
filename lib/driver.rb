require_relative 'csv_record'
require_relative 'Trip'
require_relative 'Passenger'

module RideShare

  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips


      if @vin.length != 17
        raise ArgumentError, "Vin is not the right length"
      end

      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise ArgumentError, " Status needs to be either Available or Unavailable"
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if trips.length == 0
        return 0
      end

      total_ratings = 0
      trips.each do |trip|
        total_ratings += trip.rating.to_f
      end

      return total_ratings / trips.length
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
