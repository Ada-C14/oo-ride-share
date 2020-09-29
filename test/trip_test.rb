require_relative 'test_helper'

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

    it "raises an error for invalid time" do

      #passenger = Passenger.new(id:3, name:'Carol', phone_number: '545-545-454')

      expect do
      # arrange
      RideShare::Trip.new( id: 3,
          #passenger:passenger,
                          passenger_id: 54,
                          start_time:Time.parse('2018-12-27 05:39:05'),
                          end_time:Time.parse('2018-12-27 03:38:08'),
                          cost:12,
                          rating:4 )

      # assert
      end.must_raise ArgumentError

    end

    it "tests the duration of time" do
      expect(@trip.duration).must_be_instance_of Integer
      expect(@trip.duration).must_be :>, 0
    end

  end
end
