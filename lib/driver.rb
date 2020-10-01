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

    # def average_rating
    #   if @trips.empty?
    #     return 0
    #   else
    #     average_rating = @trips.sum {|trip| trip.rating} / @trips.length
    #     return average_rating.to_f
    #   end
    #   # average_rating = @trips.sum {|trip| trip.rating} / @trips.length
    #   # return average_rating.to_f
    # end

    def average_rating
      # need to account if rating is nil
      total_rating = 0
      nil_count = 0
      if @trips.empty?
        return 0
      else
        # sum_rating = @trips.sum {|trip| trip.rating }
        # avg_rating = (sum_rating / @trips.size).to_f
        # return avg_rating
        @trips.each do |trip|
          if trip.end_time == nil
            total_rating += 0
            nil_count += 1
          else
            total_rating += trip.rating
          end
        end
      end

      total_avg_rating = (total_rating / (@trips.size - nil_count)).to_f
      return total_avg_rating

    end

    def total_revenue
      # how to account when cost is nil?
      # sum = @trips.sum {|trip|
      #   if trip.cost < 1.65
      #     return 0
      #   else
      #     (trip.cost - FEE ) * DRIVER_COMMISSION
      #   end
      # }
      # #total_earned = (sum * DRIVER_COMMISSION) - (@trips.size * FEE)
      # return sum

      total_sum = 0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          if trip.end_time == nil
            total_sum += 0
          elsif trip.cost < 1.65
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
