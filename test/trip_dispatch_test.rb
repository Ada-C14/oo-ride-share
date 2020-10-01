require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'
SELECT_DRIVER_TEST_DATA_DIRECTORY = 'test/test_data_select_driver'

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
      directory: TEST_DATA_DIRECTORY
    )
  end

  def build_select_driver_test_dispatcher
    return RideShare::TripDispatcher.new(
      directory: SELECT_DRIVER_TEST_DATA_DIRECTORY
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

  describe "Request_trip method" do
    before do
      @dispatcher = build_test_dispatcher
      @correct_driver = @dispatcher.select_driver
    end

    let (:trip_1)  {
      @dispatcher.request_trip(1)
    }

    it "request trip was created correctly" do
      expect(trip_1.passenger_id).must_equal 1
      expect(trip_1.id).must_equal 6
      expect(trip_1.driver_id).must_equal @correct_driver.id
      expect(trip_1.start_time).must_be_kind_of Time
      expect(trip_1.end_time).must_be_nil
      expect(trip_1.cost).must_be_nil
      expect(trip_1.rating).must_be_nil
    end

    it "Picked an available driver" do
      trip_1
      expect(trip_1.driver_id).must_equal @correct_driver.id
    end

    it "driver status changed to UNAVAILABLE" do
      trip_1
      expect(@correct_driver.status).must_equal :UNAVAILABLE
    end

    it "were the trip lists for the driver updated?" do
      driver_start = @correct_driver.trips.length
      trip_1
      expect(@correct_driver.trips.length).must_equal driver_start + 1
    end

    it "were the trip lists for the passenger updated?" do
      passenger_start = @dispatcher.find_passenger(1).trips.length
      trip_1
      expect(@dispatcher.find_passenger(1).trips.length).must_equal passenger_start + 1
    end

    it "no available drivers returns nil" do
      trip_1
      @dispatcher.request_trip(1)
      expect(@dispatcher.request_trip(1)).must_be_nil
    end
  end

  describe "select_driver method" do
    before do
      @dispatcher = build_select_driver_test_dispatcher
      @correct_driver = @dispatcher.select_driver
    end
    it "check there are no in-progress trips selected" do

    end

    it "pick driver that has never driven" do

    end

    it "If all drivers have driven, pick one that's driven last" do

    end
  end
end


# 1. Driver must not have in progress trips
# 2. If there are drivers that have never driven, pick one first
# 3.If all drivers have driven, pick one that's driven last
