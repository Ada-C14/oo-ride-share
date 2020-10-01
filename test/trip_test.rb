require_relative 'test_helper'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(
            id: 54,
            name: "Rogers Bartell IV",
            vin: "1C9EVBRM0YBC564DZ"
        ),
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
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

    it 'raises an error if start_time > end_time' do
      start_time = Time.now
      end_time = start_time - 25 * 60 # 25 minutes

      @trip_data[:start_time] = start_time
      @trip_data[:end_time] = end_time

      expect{ RideShare::Trip.new(@trip_data) }.must_raise ArgumentError
    end

    it "converts duration to seconds" do
      start_time = Time.parse("2018-12-27 02:39:05 -0800")
      end_time = Time.parse("2018-12-27 03:38:08 -0800")

      @trip_data[:start_time] = start_time
      @trip_data[:end_time] = end_time
      @trip = RideShare::Trip.new(@trip_data)

      expect(@trip.duration_in_seconds).must_equal 3543.0
    end
  end
end
