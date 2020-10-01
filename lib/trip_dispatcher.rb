require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

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

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      return nil if passenger_id == nil || passenger_id.class != Integer

      # Tries to lazily find the passenger assuming array indexing
      unless @passengers[passenger_id - 1]&.id == passenger_id
        return nil unless find_passenger(passenger_id)
      end

      driver_pool = filter_available_drivers
      trip_driver = select_driver(driver_pool)

      # # Find a driver, returning nil if there are no available drivers
      # trip_driver = nil
      # driver_index = @drivers.find_index { |driver| driver.status == :AVAILABLE }
      # return nil unless driver_index
      # trip_driver = @drivers[driver_index]
      # return nil if trip_driver == nil

      new_trip = Trip.new(
          id: @trips.length + 1,
          passenger: find_passenger(passenger_id),
          passenger_id: passenger_id,
          driver: trip_driver,
          driver_id: trip_driver.id,
          start_time: Time.now,
          end_time: nil,
          rating: nil,
          cost: nil
      )

      find_driver(trip_driver.id).take_trip(new_trip)
      new_trip.passenger.add_trip(new_trip)

      @trips << new_trip
      return new_trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end

      return trips
    end

    def filter_available_drivers
      # Eliminate unavailable drivers and create list of driver IDs
      driver_pool = @drivers.select { |driver| driver.status == :AVAILABLE }
      driver_pool = driver_pool.map { |driver| driver.id }
      # Find trips in progress
      in_progress_trips = @trips.select { |trip| trip.end_time.nil? }
      # Find drivers currently taking a trip
      currently_driving = in_progress_trips.map { |trip| trip.driver_id}.uniq

      # Finalize driver pool
      driver_pool -= currently_driving

      return driver_pool
    end

    def select_driver(driver_pool)

    end
  end
end
