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

    def request_trip(passenger_id)
      available_drivers = []
      drivers.each do |driver|
        if driver.status == :AVAILABLE
          available_drivers << driver
        end
      end

      if available_drivers.nil? || available_drivers == []
        raise ArgumentError, "There is no available drivers"
      end
      #chosen_driver = available_drivers.first
      chosen_driver = available_drivers.find do |driver|
        driver.trips.length == 0
      end


      chosen_driver ||= available_drivers.min_by {|driver| driver.trips.last.end_time}


      passenger = find_passenger(passenger_id)
      driver = chosen_driver #available_drivers.first


      trip_request = Trip.new(id: @trips.length + 1, passenger:passenger, driver:driver, start_time: Time.now, end_time: nil, cost: nil, rating: nil)

      driver.request_trip_helper(trip_request)
      @trips << trip_request
      return trip_request
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
