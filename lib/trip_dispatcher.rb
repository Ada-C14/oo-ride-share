require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'driver'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
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

    def get_available_drivers
      available_drivers = []
      drivers.each do |driver|
        if driver.status == :AVAILABLE
          available_drivers << driver
        end
      end

      if available_drivers.nil? || available_drivers == []
        raise ArgumentError, "There is no available drivers"
      end

      return available_drivers
    end

    def choose_driver(available_drivers)
      chosen_driver = available_drivers.find do |driver|
        driver.trips.length == 0
      end

      driver_old = available_drivers.first
      oldest_time = Time.now
      available_drivers.each do |driver|
        driver.trips.each do |trip|
          if trip.end_time < oldest_time
            oldest_time = trip.end_time
            driver_old = driver
          end
        end
      end

      return chosen_driver || driver_old
    end

    def request_trip(passenger_id)
      available_drivers = get_available_drivers

      chosen_driver = choose_driver(available_drivers)
      passenger = find_passenger(passenger_id)


      new_trip = Trip.new(id: @trips.length + 1, passenger: passenger, driver: chosen_driver, start_time: Time.now, end_time: nil, cost: nil, rating: nil)

      chosen_driver.request_trip_helper(new_trip)

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
  end
end
