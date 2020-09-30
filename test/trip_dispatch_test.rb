# frozen_string_literal: true

require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'

describe 'TripDispatcher class' do
  def build_test_dispatcher
    RideShare::TripDispatcher.new(
      directory: TEST_DATA_DIRECTORY
    )
  end

  describe 'Initializer' do
    it 'is an instance of TripDispatcher' do
      dispatcher = build_test_dispatcher
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it 'establishes the base data structures when instantiated' do
      dispatcher = build_test_dispatcher
      %i[trips passengers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end

      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      # expect(dispatcher.drivers).must_be_kind_of Array
    end

    it 'loads the development data by default' do
      # Count lines in the file, subtract 1 for headers
      trip_count = `wc -l 'support/trips.csv'`.split(' ').first.to_i - 1

      dispatcher = RideShare::TripDispatcher.new

      expect(dispatcher.trips.length).must_equal trip_count
    end
  end

  describe 'passengers' do
    describe 'find_passenger method' do
      before do
        @dispatcher = build_test_dispatcher
      end

      it 'throws an argument error for a bad ID' do
        expect { @dispatcher.find_passenger(0) }.must_raise ArgumentError
      end

      it 'finds a passenger instance' do
        passenger = @dispatcher.find_passenger(2)
        expect(passenger).must_be_kind_of RideShare::Passenger
      end
    end

    describe 'Passenger & Trip loader methods' do
      before do
        @dispatcher = build_test_dispatcher
      end

      it 'accurately loads passenger information into passengers array' do
        first_passenger = @dispatcher.passengers.first
        last_passenger = @dispatcher.passengers.last

        expect(first_passenger.name).must_equal 'Passenger 1'
        expect(first_passenger.id).must_equal 1
        expect(last_passenger.name).must_equal 'Passenger 8'
        expect(last_passenger.id).must_equal 8
      end

      it 'connects trips and passengers' do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.passenger).wont_be_nil
          expect(trip.passenger.id).must_equal trip.passenger_id
          expect(trip.passenger.trips).must_include trip
        end
      end
    end
  end

  describe 'drivers' do
    describe 'find_driver method' do
      before do
        @dispatcher = build_test_dispatcher
      end

      it 'throws an argument error for a bad ID' do
        expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
      end

      it 'finds a driver instance' do
        driver = @dispatcher.find_driver(2)
        expect(driver).must_be_kind_of RideShare::Driver
      end
    end

    describe 'Driver & Trip loader methods' do
      before do
        @dispatcher = build_test_dispatcher
      end

      it 'accurately loads driver information into drivers array' do
        first_driver = @dispatcher.drivers.first
        last_driver = @dispatcher.drivers.last

        expect(first_driver.name).must_equal 'Driver 1 (unavailable)'
        expect(first_driver.id).must_equal 1
        expect(first_driver.status).must_equal :UNAVAILABLE
        expect(last_driver.name).must_equal 'Driver 3 (no trips)'
        expect(last_driver.id).must_equal 3
        expect(last_driver.status).must_equal :AVAILABLE
      end

      it 'connects trips and drivers' do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.driver).wont_be_nil
          expect(trip.driver.id).must_equal trip.driver_id
          expect(trip.driver.trips).must_include trip
        end
      end
    end

    describe 'Requesting a Trip' do
      before do
        @dispatcher = build_test_dispatcher
        @passenger_id = 1
      end
      it 'Requests a new trip by returning a Trip object' do
        expect(@dispatcher.request_trip(@passenger_id)).must_be_instance_of RideShare::Trip
      end

      it 'accurately creates a trip' do
        new_trip = @dispatcher.request_trip(@passenger_id)
        expect(new_trip.id).must_equal @dispatcher.trips.length
        expect(new_trip.passenger).must_equal @dispatcher.find_passenger(@passenger_id)
        expect(new_trip.passenger_id).must_equal @passenger_id
        expect(new_trip.start_time).must_be_instance_of Time
        expect(new_trip.end_time).must_be_nil
        expect(new_trip.cost).must_be_nil
        expect(new_trip.rating).must_be_nil
        expect(new_trip.driver_id).must_equal 2
        expect(new_trip.driver).must_equal @dispatcher.find_driver(2)
      end

      it "updates the trips list for driver and passenger" do
        new_trip = @dispatcher.request_trip(@passenger_id)
        assigned_driver = @dispatcher.find_driver(2)
        assigned_passenger = @dispatcher.find_passenger(@passenger_id)
        expect(assigned_driver.trips.length).must_equal 4
        expect(assigned_passenger.trips.length).must_equal 2
      end

      it "selected driver becomes unavailable" do
        new_trip = @dispatcher.request_trip(@passenger_id)
        assigned_driver = @dispatcher.find_driver(2)
        expect(assigned_driver.status).must_equal :UNAVAILABLE
      end

      it "throws an ArgumentError when no drivers are available" do
        @dispatcher.request_trip(@passenger_id)
        @dispatcher.request_trip(@passenger_id)
        expect do
          @dispatcher.request_trip(@passenger_id)
        end.must_raise ArgumentError
      end

      it "adds new trip to trips list" do
        new_trip = @dispatcher.request_trip(@passenger_id)
        expect(@dispatcher.trips.length).must_equal 6
      end
    end
  end
end
