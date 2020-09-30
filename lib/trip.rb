# frozen_string_literal: true

require 'csv'
require 'time'
require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver_id, :driver

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
      if (end_time - start_time).negative?
        raise ArgumentError, 'Invalid trip time - end time must be later than start time'
      end

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id

      elsif passenger_id
        @passenger_id = passenger_id

      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end

      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating

      raise ArgumentError, "Invalid rating #{@rating}" if @rating > 5 || @rating < 1

      if driver
        @driver = driver
        @driver_id = driver.id

      elsif driver_id
        @driver_id = driver_id
        all_drivers = Driver.load_all(directory: './support')
        
      else
        raise ArgumentError, 'Driver or driver_id is required'
      end
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{object_id.to_s(16)} " \
        "id=#{id.inspect} " \
        "passenger_id=#{passenger&.id.inspect} " \
        "start_time=#{start_time} " \
        "end_time=#{end_time} " \
        "cost=#{cost} " \
        "rating=#{rating}>"
    end

    def connect(passenger, driver)
      @passenger = passenger
      passenger.add_trip(self)

      @driver = driver
      driver.add_trip(self)
    end

    def trip_duration
      @end_time - @start_time
    end

    def self.from_csv(record)
      new(
        id: record[:id],
        driver_id: record[:driver_id],
        passenger_id: record[:passenger_id],
        start_time: Time.parse(record[:start_time]),
        end_time: Time.parse(record[:end_time]),
        cost: record[:cost],
        rating: record[:rating]
      )
    end
  end
end
