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

    def find_available_drivers
      available_drivers = @drivers.select { |driver| driver.status == :AVAILABLE }
      if available_drivers.empty?
        raise ArgumentError, "currently there are no available drivers"
      end
      return available_drivers
    end

    def request_trip(passenger_id)
      available_drivers = find_available_drivers
      selected_driver = available_drivers[0]

      new_trip = RideShare::Trip.new(
        id: (@trips.length + 1),
        driver: selected_driver,
        driver_id: nil,
        passenger: find_passenger(passenger_id),
        passenger_id: passenger_id,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      )
      selected_driver.make_driver_unavailable
      selected_driver.add_trip(new_trip)

      current_passenger = find_passenger(passenger_id)
      current_passenger.add_trip(new_trip)

      @trips << new_trip

      return new_trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        driver = find_driver(trip.driver_id)
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger, driver)
      end

      return trips
    end
  end
end
