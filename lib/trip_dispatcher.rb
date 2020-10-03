require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'

module RideShare

  class NoDriverAvailableError < StandardError

  end

  class TripDispatcher
    attr_accessor :drivers, :passengers, :trips

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

    def request_trip(passenger_id)

      selected_driver = nil

      @drivers.each do |driver_instance|
        if driver_instance.status == :AVAILABLE
          selected_driver = driver_instance
          break
        end
      end

      raise NoDriverAvailableError.new if selected_driver.nil?

          passenger_identified = find_passenger(passenger_id)

      trip_id = @trips.length + 1

      trip_created = Trip.new(
          id: trip_id,
          passenger: passenger_identified,
          # passenger_id: passenger_id,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil,
          #driver_id:,
          driver: selected_driver
          )
      #BLOCK OF CODE TO FIND THE FIRST AVAILABLE DRIVER/ ASSIGNING DRIVER
      # CSV.read('support/drivers.csv').each do |row|
      #   driver_instance = Driver.new(row[0].to_i, row[1], row[2], row[3].to_sym)
      #   if driver_instance.status == :AVAILABLE
      #     trip_created.driver = driver_instance
      #     break
      #   end
      # end


      selected_driver.accept_trip_request(trip_created)

      passenger_identified.add_trip(trip_created)

      @trips << trip_created

      return trip_created
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
