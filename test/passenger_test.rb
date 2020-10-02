require_relative 'test_helper'
require 'time'

describe "Passenger class" do
  before do
    @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    @driver = RideShare::Driver.new(id: 54, name: "Test Driver", vin: "12345678901234567", status: :AVAILABLE)
    @trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: Time.parse("2018-12-17 02:39:05 -0800"),
        end_time: Time.parse("2018-12-17 03:38:08 -0800"),
        cost: 23.45,
        rating: 3
    )

    @trip_two = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        driver: @driver,
        start_time: Time.parse("2018-12-17 02:39:05 -0800"),
        end_time: Time.parse("2018-12-17 03:38:08 -0800"),
        cost: 23.45,
        rating: 3
    )
    @no_trip_passenger = RideShare::Passenger.new(id: 2, name: "taylor", phone_number: "555-838-9382")
  end
  describe "Passenger instantiation" do

    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy", phone_number: "353-533-5334")
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

      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
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
        expect(trip.passenger.id).must_equal 1
      end
    end
  end

  describe "net_expenditures" do
    it "calculates the total amount a passenger spent on a trip" do


      @passenger.add_trip(@trip)
      @passenger.add_trip(@trip_two)

      total_trip_spent = 46.90
      net_expenditures = @passenger.net_expenditures

      expect(net_expenditures).must_equal total_trip_spent
    end

    it "raises an ArgumentError if a passenger has 0 trips" do

      expect do
        @no_trip_passenger.net_expenditures
      end.must_raise ArgumentError
    end
  end

  describe "total_time_spent" do
    it "calculates the total amount of time a passenger spent on all trips" do

      @passenger.add_trip(@trip)
      @passenger.add_trip(@trip_two)
      # total_time_spent = 7086.0
      total_time_spent = @passenger.total_time_spent
      expect(total_time_spent).must_equal 7086.0
    end
    it "raises an ArgumentError if a passenger has 0 trips" do
      expect do
        @no_trip_passenger.total_time_spent
      end.must_raise ArgumentError
    end
  end
end
