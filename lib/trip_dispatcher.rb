require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory) # => returns an array of passenger instances and stores it into @passengers instance variable
      @trips = Trip.load_all(directory: directory) # => returns an array of trip instances and stores it into @trips instance variable
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    #TO-DO: add find_driver that looks up a driver by ID
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

    #Wave 3
    def request_trip(passenger_id)

      @passenger = self.find_passenger(passenger_id)

      #raises an argument error if there's no available driver
      if @drivers.find {|driver| driver.status == :AVAILABLE}.nil?
        raise ArgumentError.new("No available drivers.")
      else
        @driver = find_first_available_driver # => first_driver is the first  driver instance that's available
      end


      # do I need to create a new instance of Passenger?
      # new_passenger = Passenger.new(
      #     id: passenger_id,
      #     name: "Smithy",
      #     phone_number: "353-533-5334",
      #     trips: []
      # )



      new_trip = Trip.new(
          # what should the id of this trip be?
          id: @trips.last.id + 1,
          passenger: @passenger,
          passenger_id: passenger_id,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil,
          driver_id: @driver.id,
          driver: @driver
      )

      @driver.change_status #=> what is this doing?, adding the new trip to the collection of trips for that driver

      # why wouldn't I do this?
      @passenger.add_trip(new_trip)
      @driver.add_trip(new_trip)

      # or something like this?
      # how to add the new_trip instance to the Passenger's list of trips?
      @trips << new_trip

      return new_trip


    end

    def find_first_available_driver
        return @drivers.find {|driver| driver.status == :AVAILABLE}
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        #driver add
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end
      return trips
    end
  end
end
