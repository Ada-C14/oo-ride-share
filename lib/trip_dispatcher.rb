require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :driver, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @driver = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      Driver.validate_id(id)
      return @driver.find { |driver| driver.id == id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{driver.count} drivers, \
              #{passengers.count} passengers>"
    end


    def request_trip(passenger_id)
      unless @driver.find {|driver| driver.status == :AVAILABLE}
        raise ArgumentError, 'Sorry, no driver is available now.'
      end

      trip_drivers = (@driver.select {|driver| driver.status == :AVAILABLE})
                        .select {|driver| driver.trips == [] || driver.trips.last.end_time != nil }

      driver_with_no_trip = trip_drivers.find {|driver| driver.trips == []}
      if driver_with_no_trip
        trip_driver = driver_with_no_trip
      else
        trip_driver = trip_drivers.min_by {|driver| driver.trips.last.end_time }
      end

      trip = Trip.new(id: (@trips.length + 1),
                                        passenger: find_passenger(passenger_id),
                                        passenger_id: passenger_id,
                                        start_time: Time.now,
                                        end_time: nil,
                                        cost: nil,
                                        rating: nil,
                                        driver: trip_driver,
                                        driver_id: trip_driver.id)
      trip.connect(trip.passenger, trip.driver)
      @trips << trip
      trip_driver.status = :UNAVAILABLE
      return trip
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
