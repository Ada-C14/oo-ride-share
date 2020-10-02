require_relative 'csv_record'


module RideShare
  class Driver < CsvRecord
    VALID_STATUSES = [:AVAILABLE , :UNAVAILABLE]

    attr_reader :id, :name, :vin, :status, :trips
    attr_writer :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      validate_status(status)
      @status = status
      @name = name
      validate_vin(vin)
      @vin = vin
      @trips = trips
    end

    def validate_vin(vin)
      if vin.length != 17
        raise ArgumentError.new("Invalid vin. Must be 17 digits.")
      end
    end

    def validate_status(status)
      if !VALID_STATUSES.include?(status)
        raise ArgumentError.new("Invalid status.")
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      return 0 if @trips == []
      sum = 0
      @trips.each do |trip|
        sum += trip.rating.to_f
      end
      average = sum / @trips.length
      return average
    end

    def total_revenue
      return 0 if @trips == []
      sum = 0
      @trips.each do |trip|
        if trip.cost.to_f >= 1.65
          sum += trip.cost.to_f - 1.65
        end
      end
      return (sum * 0.8).round(2)
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