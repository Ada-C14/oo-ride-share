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
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
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

  describe "trip analysis" do
    before do
      @no_rider = RideShare::Passenger.new(id: 2398, name: "Ripley", phone_number: 382-293-2938, trips: [])

      start_time = Time.parse("2020-09-28 14:20:00")
      end_time = Time.parse("2020-09-28 15:00:00")
      start_time_2 = Time.parse("2020-09-27 14:20:00")
      end_time_2 = Time.parse("2020-09-27 15:00:00")
      @passenger = RideShare::Passenger.new(id: 6, name: "Jane Fonda", phone_number: 602-233-6200, trips: [])
      trip1 = RideShare::Trip.new(id: 2398, passenger_id: 6, start_time: start_time, end_time: end_time, cost: 100, rating: 4)
      trip2 = RideShare::Trip.new(id: 2398, passenger_id: 6, start_time: start_time_2, end_time: end_time_2, cost: 200, rating: 2)
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
    end

    describe "net_expenditures" do
      it "adds up all costs for passenger's trips" do
        expect(@passenger.net_expenditures).must_equal 300
    end

      it "raises error if passenger has no trips" do
        expect { @no_rider.net_expenditures }.must_raise ArgumentError
      end
    # You add tests for the net_expenditures method
    end

    describe "total_time_spent" do
      it "raises error if passenger has no trips" do
        expect { @no_rider.total_time_spent }.must_raise ArgumentError
      end

      it "adds up all the time for a passenger's trips" do
        expect(@passenger.total_time_spent).must_equal 4800
      end
    end
  end
end
