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
      selected_driver = assign_driver
      if selected_driver.nil?
        raise ArgumentError, "No available drivers!"
      end

      new_trip = Trip.new(
          id: assign_id,
          passenger_id: passenger_id,
          start_time: Time.now,
          end_time: nil,
          rating: nil,
          driver: selected_driver
      )
      connect_new_trip(new_trip, passenger_id, selected_driver)
      return new_trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger)
      end

      @trips.each do |trip|
        driver = find_driver(trip.driver_id)
        trip.connect_driver(driver)
      end

      return trips
    end

    def assign_id
      return trips[-1].id + 1
    end

    def assign_driver
      driver = @drivers.find { |driver| driver.status == :AVAILABLE }
      return driver
    end

    def connect_new_trip(new_trip, passenger_id, selected_driver)
      passenger = find_passenger(passenger_id)
      passenger.add_trip(new_trip)

      selected_driver.add_trip(new_trip)

      @trips << new_trip
    end
  end
end
