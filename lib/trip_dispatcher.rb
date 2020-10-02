require 'csv'
require 'time'
require 'pry'

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

    # make new trips and appropriately assign a driver and passenger.
    def request_trip(passenger_id)

      passenger = find_passenger(passenger_id)

      # find the first available driver
      available_driver = @drivers.select { |driver| driver.status == :AVAILABLE}.first
      raise ArgumentError.new("no available driver") if available_driver.nil?

      # create new instance of Trip
      new_trip = Trip.new(
          id: @trips.length + 1,
          passenger: passenger,
          passenger_id: passenger_id,
          start_time: Time.now,
          end_time:nil,
          cost:nil,
          rating: nil,
          driver_id: available_driver.id,
          driver: available_driver
      )

      new_trip.connect(passenger, available_driver)
      available_driver.unavailable_status

      # Add the Trip to the Passenger's list of Trips
      passenger.add_trip(new_trip)
      # Add the new trip to the collection of trips for that Driver
      available_driver.add_trip(new_trip)


      # add the new trip to the list
      @trips << new_trip
      return new_trip
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
      return @trips
    end
  end
end
