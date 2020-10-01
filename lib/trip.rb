require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :driver, :driver_id, :start_time, :end_time, :cost, :rating

    def initialize(
        id:,
        passenger: nil,
        passenger_id: nil,
        driver: nil,
        driver_id: nil,
        start_time:,
        end_time: nil,
        cost: nil,
        rating: nil
        )
      super(id)

      # Uses private helper method require_one to DRY up logic a bit
      # Object OR id is required
      obj_id = require_one(passenger, passenger_id, "Passenger")
      @passenger ||= obj_id[0]
      @passenger_id ||= obj_id[1]

      obj_id = require_one(driver, driver_id, "Driver")
      @driver ||= obj_id[0]
      @driver_id ||= obj_id[1]

      # End times can be nil, but if not, check that it's after start time
      raise ArgumentError.new 'End time before start time' if end_time && start_time >= end_time
      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating

      # Same for ratings
      if @rating && (@rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "id=#{id.inspect} " +
      # Lonely operator (&) prevents passenger_id from displaying correctly
      #"passenger_id=#{passenger&.id.inspect} "
      "raw_passenger_id=#{@passenger_id} " +
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

    def duration
      return (end_time - start_time).to_i
    end

    private

    # Helper method to require either object or id for initialize methods
    # Returns an array [object, id]
    def require_one(object, id, class_name)
      if object
        object_return = object
        id_return = object.id
      elsif id
        id_return = id
      else
        raise ArgumentError, "#{class_name} or #{class_name}_id is required"
      end

      return object_return, id_return
    end

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

