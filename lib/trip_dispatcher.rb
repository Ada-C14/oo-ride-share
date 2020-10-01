# frozen_string_literal: true

require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips, :drivers

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      Driver.validate_id(id)
      @drivers.find { |drivers| drivers.id == id }
    end

    def inspect
      # Make puts output more useful
      "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      passenger = find_passenger(passenger_id)
      # find all available
      available_drivers = @drivers.find_all { |drivers| drivers.status == :AVAILABLE }
      raise ArgumentError, 'No drivers available' if available_drivers.empty?

      # find drivers with no in-progress trips
      no_ip_drivers = []
      available_drivers.each do |driver|
        nil_trip = false
        # check for trips with nil
        driver.trips.each do |trip|
          nil_trip = true if trip.end_time.nil?
        end
        # only shovel is !nil_trip
        no_ip_drivers << driver unless nil_trip
      end
      raise ArgumentError, 'No drivers available' if no_ip_drivers.empty?
      # find drivers with no trips
      driver = no_ip_drivers.find{|driver| driver.trips.empty?}
      # if result nil, all drivers have at least one trip, must compare for most "stale"
      if driver.nil?
        driver = no_ip_drivers.min_by{|driver| driver.trips.max_by{|trip| trip.end_time}}
      end

      new_trip = Trip.new(id: @trips.length + 1, passenger: passenger, driver: driver, start_time: Time.now, end_time: nil, rating: nil)

      new_trip.connect(passenger, driver)
      driver.unavailable_driver
      @trips << new_trip
      new_trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end
    end
  end
end
