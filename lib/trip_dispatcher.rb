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

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def first_available_driver
      first = @drivers.find { |driver| driver.status == :AVAILABLE }
      raise ArgumentError.new("no available drivers") if first == nil
      return first
    end

    def request_trip(passenger_id)
      current_passenger = find_passenger(passenger_id)
      current_driver = first_available_driver
      current_trip = RideShare::Trip.new(
          id: @trips.length + 1,
          driver: current_driver,
          passenger: current_passenger,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
      )
      current_passenger.add_trip(current_trip)
      current_driver.assign_new_trip(current_trip)
      @trips << current_trip
      return current_trip
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
