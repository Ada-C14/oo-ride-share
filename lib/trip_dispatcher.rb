require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @drivers = Driver.load_all(directory: directory)
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      connect_trips
    end

    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      first_available_driver = @drivers.find { |driver| driver.status == :AVAILABLE }

      if first_available_driver
        trip = Trip.new(
          id: @trips.length + 1,
          driver_id: first_available_driver.id,
          passenger_id: passenger_id,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
        )

        passenger = find_passenger(passenger_id)
        first_available_driver.start_trip(trip)
        passenger.add_trip(trip)

        @trips << trip

        return trip

      else
        raise ArgumentError, "There are no available drivers. Try requesting a trip later."
      end
    end

    private

    def connect_trips
      @trips.each do |trip|
        driver = find_driver(trip.driver_id)
        passenger = find_passenger(trip.passenger_id)
        trip.connect(driver, passenger)
      end

      return trips
    end
  end
end
