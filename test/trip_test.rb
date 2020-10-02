require_relative 'test_helper'

describe "Trip class" do

  before do
    start_time = Time.now - 60 * 60 # 60 minutes
    end_time = start_time + 25 * 60 # 25 minutes

    @start_time = start_time
    @end_time = end_time
    @driver = RideShare::Driver.new(id: 10, name: "Random Driver", vin: 12345671234567816, status: :AVAILABLE, trips: [])
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
        rating: 3,
        driver_id: 3,
        driver: @driver
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

    # Add a check in Trip#initialize that raises an ArgumentError if the end time
    # is before the start time, and IN THIS FILE: a corresponding test
    it "raises an ArgumentError if the end time is before the start time" do
      # we are exchanging the end and start time, to make them non-valid

      @trip_data[:start_time] = @end_time
      @trip_data[:end_time] = @start_time
      expect { RideShare::Trip.new(@trip_data) }.must_raise ArgumentError
    end

  end

  describe "Duration" do
    # Add an instance method to the Trip class to calculate the duration of the trip
    # in seconds, and IN THIS FILE a corresponding test
    it "calculate the duration of the trip in seconds" do

      @trip_data[:start_time] = @start_time
      @trip_data[:end_time] = @end_time
      expect(@trip.duration).must_equal 25 * 60
    end

  end
end










