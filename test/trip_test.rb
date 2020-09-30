# frozen_string_literal: true

require_relative 'test_helper'

describe 'Trip class' do
  describe 'initialize' do
    before do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(
          id: 4,
          name: 'Driver Sample',
          vin: 'WBS76FYD47DJF7206',
          status: :AVAILABLE,
          trips: []
        ),
        passenger: RideShare::Passenger.new(
          id: 1,
          name: 'Ada',
          phone_number: '412-432-7640'
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it 'is an instance of Trip' do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it 'is raises an ArgumentError if end time is before start time' do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      trip_data = {
        id: 8,
        driver: RideShare::Driver.new(
          id: 4,
          name: 'Driver Sample',
          vin: 'WBS76FYD47DJF7206',
          status: :AVAILABLE,
          trips: []
        ),
        passenger: RideShare::Passenger.new(
          id: 1,
          name: 'Ada',
          phone_number: '412-432-7640'
        ),
        start_time: end_time,
        end_time: start_time,
        cost: 23.45,
        rating: 3
      }

      expect do
        RideShare::Trip.new(trip_data)
      end.must_raise ArgumentError
    end

    it 'returns the duration of the trip in seconds' do
      expect(@trip.duration).must_equal 25 * 60
    end

    it 'stores an instance of passenger' do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it 'stores an instance of driver' do
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    it 'raises an error for an invalid rating' do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end
  end
end
