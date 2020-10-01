require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
      directory: TEST_DATA_DIRECTORY
    )
  end

  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = build_test_dispatcher
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = build_test_dispatcher
      [:trips, :passengers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end

      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      # expect(dispatcher.drivers).must_be_kind_of Array
    end

    it "loads the development data by default" do
      # Count lines in the file, subtract 1 for headers
      trip_count = %x{wc -l 'support/trips.csv'}.split(' ').first.to_i - 1

      dispatcher = RideShare::TripDispatcher.new

      expect(dispatcher.trips.length).must_equal trip_count
    end
  end

  describe "passengers" do
    describe "find_passenger method" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "throws an argument error for a bad ID" do
        expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
      end

      it "finds a passenger instance" do
        passenger = @dispatcher.find_passenger(2)
        expect(passenger).must_be_kind_of RideShare::Passenger
      end
    end

    describe "Passenger & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "accurately loads passenger information into passengers array" do
        first_passenger = @dispatcher.passengers.first
        last_passenger = @dispatcher.passengers.last

        expect(first_passenger.name).must_equal "Passenger 1"
        expect(first_passenger.id).must_equal 1
        expect(last_passenger.name).must_equal "Passenger 8"
        expect(last_passenger.id).must_equal 8
      end

      it "connects trips and passengers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.passenger).wont_be_nil
          expect(trip.passenger.id).must_equal trip.passenger_id
          expect(trip.passenger.trips).must_include trip
        end
      end
    end
  end

  # TODO: un-skip for Wave 2
  describe "drivers" do
    describe "find_driver method" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "throws an argument error for a bad ID" do
        expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
      end

      it "finds a driver instance" do
        driver = @dispatcher.find_driver(2)
        expect(driver).must_be_kind_of RideShare::Driver
      end
    end

    describe "Driver & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "accurately loads driver information into drivers array" do
        first_driver = @dispatcher.drivers.first
        last_driver = @dispatcher.drivers.last

        expect(first_driver.name).must_equal "Driver 1 (unavailable)"
        expect(first_driver.id).must_equal 1
        expect(first_driver.status).must_equal :UNAVAILABLE
        expect(last_driver.name).must_equal "Driver 3 (no trips)"
        expect(last_driver.id).must_equal 3
        expect(last_driver.status).must_equal :AVAILABLE
      end

      it "connects trips and drivers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.driver).wont_be_nil
          expect(trip.driver.id).must_equal trip.driver_id
          expect(trip.driver.trips).must_include trip
        end
      end
    end
  end

  describe "request a new trip" do
    before do
      @dispatcher = build_test_dispatcher
    end

    passenger_id = 6
    it "works for request_trip" do
      expect(@dispatcher.request_trip(passenger_id)).must_be_kind_of RideShare::Trip
    end

    it "finds the first available driver and changes status to :UNAVAILABLE" do
      expect(@dispatcher.request_trip(passenger_id).driver_id).must_equal 2
      expect(@dispatcher.request_trip(passenger_id).driver.status).must_equal :UNAVAILABLE
    end

    it "checks that requested trip has the right parameters" do
      passenger_id = 6
      trip = @dispatcher.request_trip(passenger_id)

      expect(trip.passenger_id).must_equal 6
      expect(trip.id).must_equal 6
      expect(trip.end_time).must_be_nil
      expect(trip.cost).must_be_nil
      expect(trip.rating).must_be_nil
    end

    it "checks that trip id increments by 1" do
      array = [6, 7]
      trip_id = 5

      array.each do |pass|
        trip = @dispatcher.request_trip(pass)
        expect(trip.id).must_equal trip_id += 1
      end
    end

    it "raises an error for no driver available" do
      array = [6, 7, 3]

      expect{
        array.each do |pass|
          @dispatcher.request_trip(pass)
        end}.must_raise ArgumentError
    end

    it "checks a trip is added to passenger trips" do
      passenger_id = 6
      trip = @dispatcher
      expect(trip.find_passenger(passenger_id).trips.count).must_equal 1

      # after request a trip
      trip.request_trip(passenger_id)
      expect(trip.find_passenger(passenger_id).trips.count).must_equal 2

    end

    it "checks a trip is added to driver trips" do

      passenger_id = 6
      driver_id = 2

      trip = @dispatcher

      # trip = @dispatcher.request_trip(passenger_id)
      expect(trip.find_driver(driver_id).trips.count).must_equal 3

      # after request a trip
      trip.request_trip(passenger_id)
      expect(trip.find_driver(driver_id).trips.count).must_equal 4

    end
  end
end

# TESTS NEEDED FOR WAVE 3 #

# - checks if adds trip to passenger trip list
# - checks if and adds trip to driver's trip list

