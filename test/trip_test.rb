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
        rating: 3,
        driver: RideShare::Driver.new(
            id: 2,
            name: "Tram",
            vin: "WBS76FYD47DJF7206",
            status: :AVAILABLE
        )
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
      #skip # Unskip after wave 2
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

    it "raises an error for an invalid time (end time is before start time)" do
      #act
      @trip_data[:end_time] = @trip_data[:start_time] - 1
      #assert
      expect{ RideShare::Trip.new(@trip_data) }.must_raise ArgumentError

    end


    # my test for
    # it "raises an error when end time is before start time" do
    #   #arrange
    #   @trip_data[:end_time] = @trip_data[:start_time] - 180 * 60
    #   #act and assert
    #   expect{
    #     RideShare::Trip.new(@trip_data)
    #   }.must_raise ArgumentError
    #
    # end

  end

  describe "trip_duration_in_secs" do
    it "should return the accurate trip duration in secs" do

      trip_duration = @trip.end_time - @trip.start_time
      #test = @trip.trip_duration_in_secs
      expect(@trip.duration).must_equal trip_duration

    end

    it "should raise an error if trip is still in progress" do
      trip_data = {
          id: 8,
          passenger: RideShare::Passenger.new(
              id: 1,
              name: "Ada",
              phone_number: "412-432-7640"
          ),
          start_time: Time.now,
          end_time: nil,
          cost: 23.45,
          rating: 3,
          driver: RideShare::Driver.new(
              id: 2,
              name: "Tram",
              vin: "WBS76FYD47DJF7206",
              status: :AVAILABLE
          )
      }

      expect {
        RideShare::Trip.new(trip_data).duration
      }.must_raise ArgumentError

    end

  end
end
