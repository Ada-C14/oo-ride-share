require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

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

    def average_rating
      sum_of_ratings = 0.00
      average = 0.00
      in_progress_trips = 0
      if @trips.empty?
        return average
      else
        @trips.map do |trip|
          if trip.rating == nil
            in_progress_trips += 1
            next
          else
          sum_of_ratings += trip.rating.to_f
          end
        end
        if in_progress_trips > 0
          average = (sum_of_ratings/(@trips.length - in_progress_trips)).to_f.round(2)
        else
          average = (sum_of_ratings/@trips.length).to_f.round(2)
        end
      end
        return average
    end

    def total_revenue
      revenue = 0.00
      return 0.00 if @trips.empty?
      @trips.each do |trip|
        if trip.cost == nil
          next
        elsif trip.cost < 1.65
          next
        else
          revenue += ((trip.cost - 1.65)*0.8)
        end
      end
      return revenue
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

