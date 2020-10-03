require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'
#TEST_DATA_DIRECTORY = './test_data'

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
      directory: TEST_DATA_DIRECTORY
    )
  end

  describe "Requesting Trips" do
    # before do
    #   # Will use the information created below to test requesting_trips
    #   @test_passenger = RideShare::Passenger.new(
    #       id: 1,
    #       name: "Passenger 1",
    #       phone_number:"111-111-1111",
    #       )
    #   @test_driver = RideShare::Driver.new(
    #       id: 1,
    #       name: "Driver 1",
    #       vin: "1B6CF40K1J3Y74UY0"
    #       )
    #   @test_trip = {
    #       id: 6,
    #       passenger: @test_passenger,
    #       start_time: Time.now,
    #       end_time: nil,
    #       rating: nil,
    #       driver: @test_driver
    #   }

      # gives me an error when I delete from the it block below and paste here
      # dispatcher = build_test_dispatcher
      # actual_trip = dispatcher.request_trip(1)
    # end

    it "created trip properly" do
      dispatcher = build_test_dispatcher
      actual_trip = dispatcher.request_trip(1)
      expect(actual_trip).must_be_kind_of RideShare::Trip
      expect(actual_trip.passenger_id).must_equal 1
      expect(actual_trip.driver).must_be_kind_of RideShare::Driver
      expect(actual_trip.driver.name).must_equal "Driver 2"
      expect(actual_trip.cost).must_equal 0
      expect(actual_trip.end_time).must_be_nil
      expect(actual_trip.passenger).must_be_kind_of RideShare::Passenger
      expect(actual_trip.rating).must_equal 0
      expect(actual_trip.start_time).must_be_kind_of Time
      expect(actual_trip.id).must_equal dispatcher.trips.length
    end

      it "updated the driver trip list" do
        dispatcher = build_test_dispatcher
        actual_trip = dispatcher.request_trip(1)
        expect(actual_trip.driver.trips).must_include actual_trip
      end

      it "updated the passenger trip list" do
        dispatcher = build_test_dispatcher
        actual_trip = dispatcher.request_trip(1)
        expect(actual_trip.passenger.trips).must_include actual_trip
      end

      it "updated the driver's status" do
        dispatcher = build_test_dispatcher
        actual_trip = dispatcher.request_trip(1)
        expect(actual_trip.driver.status).must_equal :UNAVAILABLE
      end

      it "selected a different driver" do
        dispatcher = build_test_dispatcher
        actual_trip = dispatcher.request_trip(1)
        actual_trip2 = dispatcher.request_trip(2)
        expect(actual_trip.driver).wont_equal(actual_trip2.driver)

      end

      it "resolves situation if somebody requests a trip when there are no drivers available" do
        dispatcher = build_test_dispatcher
        actual_trip_1 = dispatcher.request_trip(1)
        actual_trip_2 = dispatcher.request_trip(2)
        expect{
          actual_trip_3 = dispatcher.request_trip(3)
        }.must_raise RideShare::NoDriverAvailableError
        # note that there are only two available drivers so the third person requesting a trip
        # should not be assigned a driver, but an error message instead
        # edit the part of the code that deals with raising an ArgumentError
      end

      it "resolves situation if attempt to calculate money spent for passenger with an in-progress trip" do
        dispatcher = build_test_dispatcher
        passenger_instance = dispatcher.find_passenger(1)
        expenditures_before_request_trip = passenger_instance.net_expenditures
        actual_trip_1 = dispatcher.request_trip(1)
        expect(actual_trip_1.passenger.net_expenditures).must_equal expenditures_before_request_trip
      end

      it "resolves situation if attempt to calculate average rating for driver with an in-progress trip" do
        dispatcher = build_test_dispatcher
        #looking at the csv file, driver #1 is already unavailable, so we know it's gonna be driver # 2
        driver_instance = dispatcher.find_driver(2)
        average_rating_before_request_trip = driver_instance.average_rating
        actual_trip_1 = dispatcher.request_trip(1)
        expect(actual_trip_1.driver.average_rating).must_equal average_rating_before_request_trip
      end
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
      trip_count = 600
      #trip_count = %x{wc -l 'support/trips.csv'}.split(' ').first.to_i - 1
      #ORIGINAL COMMAND
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


end
