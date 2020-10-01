require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      @name = name
      raise ArgumentError if vin.length != 17
      @vin = vin
      @trips = trips
      valid_status = [:UNAVAILABLE, :AVAILABLE]
      # if !(valid_status.include?(status))
      #   raise ArgumentError, "must have valid status"
      # end
      unless valid_status.include?(status)
        raise ArgumentError, "Must have valid status"
      end
      @status = status

    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      total = 0
      @trips.compact.each do |trip|
        total += trip.rating.to_f
      end
      if @trips.length == 0
        return 0
      end
      average_total = total / @trips.length
      return average_total
    end

    #Each driver gets 80% of the trip cost after a fee of $1.65 per trip
    # is subtracted.
    def total_revenue
      revenue = 0
      @trips.each do |trip|
        revenue += (@trips.cost.to_f - 1.65) * 0.8
      end

      return revenue
    end

    def trip_in_progress(trip)
      # @trips.each do |trip|
      #   if @driver.status = :AVAILABLE
      self.add_trip(trip)
      @driver.status = :UNAVAILABLE
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