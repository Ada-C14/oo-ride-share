require 'csv'
require 'time'
require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord

    # we ask attr_reader to create the following methods using the input from initialize
    attr_reader :id, :passenger_id, :start_time, :end_time, :driver_id
    attr_accessor :passenger, :driver
    def initialize(
        id:,
        passenger: nil,
        passenger_id: nil,
        start_time:,
        end_time:,
        cost: nil,
        rating:,
        driver_id: nil,
        driver: nil
    )
      super(id)
      # either define methods below OR if method is from parameter/ and attr_reader, save them below

      # must save those variable so that the methods by the same name can access them
      @cost = cost
      @rating = rating

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end

      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, 'Driver or driver_id is required'
      end

      # Modify Trip.from_csv to turn start_time and end_time into Time instances
      # before passing them to Trip#initialize
      if start_time.class == Time
        @start_time = start_time
      elsif start_time.class == String
        @start_time = Time.parse(start_time)
      else
        raise ArgumentError, ('Start time should be entered as a String or a Time Instance, Thanks so much.')
      end

      unless end_time == nil
        if end_time.class == Time
          @end_time = end_time
        elsif end_time.class == String
          @end_time = Time.parse(end_time)
        else
          raise ArgumentError, ('End time should be entered as a String or a Time Instance, Thanks so much.')
        end

        # Add a check in Trip#initialize that raises an ArgumentError if the end time
        # is before the start time, and a corresponding test
        if @end_time < @start_time
          raise ArgumentError, 'End time is less than start time'
        end
      end

      unless rating == nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end

    end

    # Add an instance method to the Trip class to calculate the duration of the trip
    # in seconds, and a corresponding test

    # we could write the inside of the code below as:
    # def duration
    # @end_time == nil ? 0 : @end_time - @start_time
    # end
    def duration
      if @end_time == nil
        trip_duration = 0
      else
        trip_duration = @end_time - @start_time
      end
        return trip_duration
    end

    def cost
      @cost == nil ? 0 : @cost
    end

    def rating
      @rating == nil ? 0 : @rating
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
          "rating=#{rating}>"
    end

    def connect(passenger, driver)
      @passenger = passenger
      passenger.add_trip(self)
      @driver = driver
      driver.add_trip(self)
    end

    private

    def self.from_csv(record)
      return self.new(
          id: record[:id].to_i,
          driver_id: record[:driver_id],
          passenger_id: record[:passenger_id],
          start_time: record[:start_time],
          end_time: record[:end_time],
          cost: record[:cost],
          rating: record[:rating],
          driver: record[:driver]
      )
    end
  end
end


