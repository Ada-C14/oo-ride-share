require_relative 'csv_record'
FEE = 1.65
DRIVER_COMMISSION = 0.8

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE , trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips


      unless @vin.size == 17
        raise ArgumentError.new("#{@vin} is not the right size")
      end

      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise ArgumentError.new("Invalid status")
      end

      # until [:AVAILABLE, :UNAVAILABLE].include?(@status)
      #   raise ArgumentError.new("Invalid status")
      # end

    end

    #TO-DO: create add_trip method
    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips.empty?
        return 0
      else
        sum_rating = @trips.sum {|trip| trip.rating}
        avg_rating = (sum_rating / @trips.size).to_f
        return avg_rating
      end

    end

    def total_revenue
      if @trips.empty?
        return 0
      else
        sum = @trips.sum {|trip| trip.cost}
        total_earned = (sum * DRIVER_COMMISSION) - (@trips.size * FEE)
        return total_earned
      end

    end

    private

    def self.from_csv(record)
      return self.new(
          id: record[:id],
          name: record[:name],
          vin: record[:vin],
          status: record[:status].to_sym)
    end
  end
end
