require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def request_trip(passenger_id)
      passenger = find_passenger(passenger_id)
      # do we need "find_driver" to validate driver_id?
      drivers_available = @drivers.select { |driver| driver.status == :AVAILABLE }

      raise ArgumentError.new("No available drivers") if drivers_available.empty?

      if drivers_available.any? { |candidate| candidate.trips.count == 0 }
        driver = drivers_available.find { |candidate| candidate.trips.count == 0 }
      else
        driver = drivers_available.min_by { |candidate| candidate.trips.last.end_time }
      end

      trip = Trip.new(id: @trips.last.id + 1, passenger: passenger, passenger_id: passenger_id, driver: driver, driver_id: driver.id, start_time: Time.now, end_time: nil, cost: nil, rating: nil)
      @trips << trip
      passenger.add_trip(trip)
      driver.add_trip(trip)
      driver.trip_in_progress
      return trip
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end
      # this was trips as a local variable before
      return @trips
    end
  end
end
