require_relative 'test_helper'

describe "Trip class" do
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

    it "start time and end time is an instance of Time" do
      expect(@trip.start_time).must_be_instance_of Time
      expect(@trip.end_time).must_be_instance_of Time
    end

    it "raises an error for invalid end time" do
      end_time = @trip_data[:start_time] - 25 * 60 # 25 minutes before start time
      @trip_data[:end_time] = end_time

      expect do
        RideShare::Trip.new(@trip_data)
      end.must_raise ArgumentError
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
  end

  describe "duration method" do

    it "test duration method for the correct amount of seconds" do
      expect(@trip.duration).must_equal 1500.0
    end
  end
end
