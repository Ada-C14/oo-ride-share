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
      #sum = 0
      sum = @trips.sum {|trip|
        if trip.cost < 1.65
          return 0
        else
          trip.cost * DRIVER_COMMISSION - FEE
        end
      }
      #total_earned = (sum * DRIVER_COMMISSION) - (@trips.size * FEE)
      return sum
    end

    private
    # implement the from_csv template method
    def self.from_csv(record)
      return self.new(
          id: record[:id],
          name: record[:name],
          vin: record[:vin],
          status: record[:status].to_sym)
    end
  end
end
