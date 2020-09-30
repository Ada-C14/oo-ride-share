require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver, :driver_id

    def initialize(
          id:,
          passenger: nil, #why is this nil?
          passenger_id: nil,
          start_time:,
          end_time:,
          cost: nil,
          rating:,
          driver_id: nil,
          driver: nil
        )

      super(id)

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id

      elsif passenger_id
        @passenger_id = passenger_id

      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end

      #do the same as above for driver?
      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, 'Driver or driver_id is required'
      end

      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      #raise an agumenterror if end time is before the start time
      if @start_time > @end_time
        raise ArgumentError.new("#{@end_time} end time is before the start time #{@start_time}")
      end

    end




    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
        "id=#{id.inspect} " +
        "passenger_id=#{passenger&.id.inspect} " +
        "start_time=#{start_time} " +
        "end_time=#{end_time} " +
        "cost=#{cost} " +
        "rating=#{rating}> " +
      "driver_id=#{driver&.id.inspect}"
    end

    def connect(passenger, driver)
      @passenger = passenger
      @driver = driver
      passenger.add_trip(self)
      driver.add_trip(self)
    end

    # def connect_driver(driver)
    #   @driver = driver
    #   driver.add_trip(self)
    # end


    def duration
      duration_in_secs = @end_time - @start_time
      return duration_in_secs
    end


    # def trip_duration_in_secs
    #   return @end_time - @start_time
    # end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               passenger_id: record[:passenger_id],
               start_time: Time.parse(record[:start_time]),
               end_time: Time.parse(record[:end_time]),
               cost: record[:cost],
               rating: record[:rating],
               driver_id: record[:driver_id],
             )
    end
  end
end
