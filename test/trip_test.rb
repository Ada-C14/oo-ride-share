require_relative 'test_helper'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(
            id: 1,
            name: "Lovelace",
            vin: "12345678901234567",
            status: :AVAILABLE
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
      # skip # Unskip after wave 2
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

    it "raises an error if end time is before start time" do
      @end_time = Time.now - 60 * 60
      @start_time = @end_time + 25 * 60

      expect {RideShare::Trip.new(@end_time)}.must_raise ArgumentError
    end
  end

  describe ".duration" do
    before do
        start_time = Time.now - 60 * 60 # 60 minutes
        end_time = start_time + 25 * 60 # 25 minutes
        @trip_data = {
          id: 8,
          driver_id: 4,
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

    it "can calculate the duration of a ride in seconds" do
      expect(@trip.duration).must_equal 1500
    end

    it "returns nil for an in-progress trip" do #TODO: how would we add this trip to 'before' passenger?
      new_trip_data = {
          id: 9,
          driver_id: 4,
          passenger: RideShare::Passenger.new(
              id: 2,
              name: "Polly",
              phone_number: "412-432-7650"
          ),
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
      }
      trip = RideShare::Trip.new(new_trip_data)
      expect(trip.duration).must_be_nil
    end
  end
end
