require_relative 'test_helper'
require 'time'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        driver: RideShare::Driver.new(
            id: 54,
            name: "Test Driver",
            vin: "12345678901234567",
            status: :AVAILABLE
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
       # Unskip after wave 2
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end

    it "raises an error if end time is before the start time" do
      start_time = Time.parse("2018-12-27 02:39:05 -800")
      end_time = Time.parse("2018-12-17 16:09:21 -800")

      if start_time < end_time
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end

    it "calculates the duration of a trip" do
      start_time = Time.parse("2018-12-27 02:39:05 -800")
      end_time = Time.parse("2018-12-27 03:38:08 -800")

      trip_duration = end_time - start_time

      expect(trip_duration).must_equal 3543.0
  end
  end
end
