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
      @drivers.each do |driver|
        if driver.id == id
          return driver
        end
      end
      return nil
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      passenger = find_passenger(passenger_id)

      available_driver = nil
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          available_driver = driver
          break
        end
      end

      trip_id = @trips.length + 1  #creating an id for a trip

      new_trip = RideShare::Trip.new(
          id: trip_id,
          passenger: passenger,
          start_time: Time.now,
          end_time: nil,
          rating: nil,
          driver: available_driver)

      available_driver.add_trip(new_trip) #adding a new trip to the driver
      available_driver.status = :UNAVAILABLE #setting his status to unavailable
      passenger.add_trip(new_trip) #adding a new trip to the passenger
      @trips << new_trip #adding a new trip to the trips array
      return new_trip
    end


    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger)
      end

      return trips
    end
  end
end
