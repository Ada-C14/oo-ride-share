require_relative 'test_helper'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end

    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end

      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end


  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver_id: 3,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 5
        )

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end

  describe "net_expenditures and total_time_spent" do
    before do
      @passenger = RideShare::Passenger.new(
          id: 9,
          name: "Merl Glover III",
          phone_number: "1-602-620-2330 x3723",
          trips: []
      )

      @trip_1 = RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          driver_id: 3,
          start_time: Time.parse("2018-12-27 02:39:05 -0800"),
          end_time: Time.parse("2018-12-27 03:38:08 -0800"),
          cost: 3,
          rating: 5
      )

      @trip_2 = RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          driver_id: 3,
          start_time: Time.parse("2019-01-09 08:30:31 -0800"),
          end_time: Time.parse("2019-01-09 08:48:50 -0800"),
          cost: 7,
          rating: 5
      )

      @trip_3 = RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          driver_id: 3,
          start_time: Time.parse("2018-11-24 15:57:18 -0800"),
          end_time: Time.parse("2018-11-24 16:01:56 -0800"),
          rating: 5
      )
      @trip_4 = RideShare::Trip.new(
          id: 9,
          passenger: @passenger,
          driver_id: 3,
          start_time: Time.parse("2018-11-24 15:57:18 -0800"),
          end_time: nil,
          rating: 5
      )
    end

    it "returns 0 for no trips" do
      expect(@passenger.net_expenditures).must_equal 0
    end

    it "returns sum of all trip costs" do
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_2)

      expect(@passenger.net_expenditures).must_equal 10
    end

    it "skips in progress trips in figuring out trip costs" do
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_3)
      @passenger.add_trip(@trip_2)

      expect(@passenger.net_expenditures).must_equal 10
    end

    it "total_time_spent returns total time of trip" do
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_2)
      @passenger.add_trip(@trip_3)

      expect(@passenger.total_time_spent).must_equal 4920
    end

    it "total_time_spent ignores in progress trips" do
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_2)
      @passenger.add_trip(@trip_4)
      @passenger.add_trip(@trip_3)

      expect(@passenger.total_time_spent).must_equal 4920
    end

  end
  end