require_relative 'test_helper'

describe "Trip class" do
  before do
    start_time = Time.now - 60 * 60 # -(60 * 60)sec = -60min to make it in the past
    end_time = start_time + 25 * 60 # 25 minutes duration of the trip starting an hour ago
    @trip_data = {
        id: 8,
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

  describe "initialize" do
    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      skip # Unskip after wave 2
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

    it"raises an error if end time is before start time" do
      start_time = Time.now - 60 * 60
      end_time = start_time - 25 * 60 # start_time - 25min => ending 25min in the past
      trip_data = {
          id: 8,
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

      expect{
        RideShare::Trip.new(trip_data)
      }.must_raise ArgumentError
    end
  end

  describe "get_duration" do
    it "return accurate duration of the trip in seconds" do
      trip_duration = @trip.end_time - @trip.start_time
      expect(trip_duration).must_be_kind_of Float
      expect(trip_duration).must_be_close_to 1500.0 #25 minutes
    end
  end
end
