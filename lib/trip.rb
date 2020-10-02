require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :driver, :driver_id, :start_time, :end_time, :cost, :rating

    def initialize(
          id:,
          driver: nil,
          driver_id: nil,
          passenger: nil,
          passenger_id: nil,
          start_time:,
          end_time:,
          cost: nil,
          rating:
        )
      super(id) #super class csv record inherits from csv initialize method self.class.validate_id(id)

      #When a Trip is constructed, either driver_id or driver must be provided.
      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, 'Driver or driver_id is required'
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


      raise ArgumentError, "End time cannot be before start time." unless @end_time.nil? || @end_time > @start_time

      @cost = cost
      @rating = rating

      unless rating.nil?
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " + #conver object id to hexidecimal (memory address)
        "id=#{id.inspect} " +
        "driver_id=#{driver&_id.inspect} " +
        "passenger_id=#{passenger&.id.inspect} " +
        "start_time=#{start_time} " +
        "end_time=#{end_time} " +
        "cost=#{cost} " +
        "rating=#{rating}>"
    end


    def connect(passenger, driver) # takes an instance of passenger and driver
      @passenger = passenger
      passenger.add_trip(self) # adds the instance of trip to passenger's trips array #self refers to Trip
      @driver = driver
      driver.add_trip(self) # adds the instance of trip to driver's trips array  #self refers to Trip
    end


    def get_duration # return duration of trip in seconds
      return @end_time - @start_time unless @end_time.nil? # returns nil if end_time is nil
    end


    private

    def self.from_csv(record)
      return self.new(
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