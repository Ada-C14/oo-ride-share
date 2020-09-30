require_relative 'test_helper'
require 'time'

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

  #TESTS FOR TOTAL_TIME_SPENT
  describe "total_time_spent" do

    before do
      @passenger_random = RideShare::Passenger.new(id: 500, name: "TestName", phone_number: "test_phone_number", trips: [])
      @trip_random = RideShare::Trip.new(id: 5, passenger: @passenger_random, start_time: Time.new(2016, 8, 8), end_time: Time.new(2016, 8, 9), rating: 5)
    end

    it "Evaluates to zero if the passenger didn't do any trips" do
      expect(@passenger_random.total_time_spent).must_equal 0
    end

    it "Evaluates to length of time of the trip if there is only one trip" do
      @passenger_random.add_trip(@trip_random)
      expect(@passenger_random.total_time_spent).must_equal 86400 #24 * 60 * 60
    end

  end

  # TESTS FOR NET_EXPENDITURES
  describe "net_expenditures" do
    before do
           @passenger = RideShare::Passenger.new(
          id: 9,
          name: "Merl Glover III",
          phone_number: "1-602-620-2330 x3723",
          trips: []
      )
    end
    it "calculates the single trip " do
      trip = RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          rating: 5,
          cost: 22
      )
      @passenger.add_trip(trip)
      expect(@passenger.net_expenditures).must_equal 22
    end
    it "calulates for no trips " do
      expect(@passenger.net_expenditures).must_equal 0
    end
    it "calulates for multiple trips " do
      trip = RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          rating: 5,
          cost: 22
      )
      @passenger.add_trip(trip)
      @passenger.add_trip(trip)
      @passenger.add_trip(trip)
      expect(@passenger.net_expenditures).must_equal 66
    end
  end

end
