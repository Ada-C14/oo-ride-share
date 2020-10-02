require_relative 'csv_record'
FEE = 1.65
DRIVER_COMMISSION = 0.8

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE , trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips

      unless @vin.size == 17
        raise ArgumentError.new("#{@vin} is not the right size")
      end

      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise ArgumentError.new("Invalid status")
      end

    end

    #TO-DO: create add_trip method
    def add_trip(trip)
      @trips << trip
    end

    # driver helper method to change driver status to unavailable
    def change_status
      @status = :UNAVAILABLE
    end


    def average_rating
      # need to account if rating is nil
      count = 0
      rating_sum = 0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          if trip.end_time == nil
            rating_sum += 0
          elsif
          rating_sum += trip.rating
            count += 1
          end
        end

      return (rating_sum/count).to_f

      end
    end

    def total_revenue

      total_sum = 0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          if trip.end_time == nil
            total_sum += 0
          elsif trip.cost < FEE
            total_sum += 0
          else
            total_sum += (trip.cost - FEE ) * DRIVER_COMMISSION
          end
        end
      end

      return total_sum

    end

    private
    # implement the from_csv template method
    def self.from_csv(record)
      return self.new(
          id: record[:id],
          name: record[:name],
          vin: record[:vin],
          status: record[:status])
    end
  end
end
