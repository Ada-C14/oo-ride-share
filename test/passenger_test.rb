require_relative 'test_helper'

describe "Passenger class" do
  before do
    @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
    )
    @driver = RideShare::Driver.new(
        id: 54,
        name: "Test Driver",
        vin: "12345678901234567",
        status: :AVAILABLE
    )
    @trip1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8, 12, 10, 00),
        end_time: Time.new(2016, 8, 8, 12, 10, 10),
        cost: 23.45,
        rating: 5,
        driver: @driver
    )
    @trip2 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8, 12, 10, 00),
        end_time: Time.new(2016, 8, 8, 12, 10, 10),
        cost: 27.45,
        rating: 5,
        driver: @driver
    )
    @trip3 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8, 12, 10, 00),
        end_time: Time.new(2016, 8, 8, 12, 10, 10),
        cost: 13.45,
        rating: 5,
        driver: @driver
    )
    @trip4 = RideShare::Trip.new(
        id: 20,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8, 12, 10, 00),
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: @driver
    )
  end
  describe "Passenger instantiation" do

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

      trip = RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          rating: 5,
          driver: @driver
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

  describe "net_expenditures" do

    it "return the total amount of money the passenger has spent" do

      @passenger.add_trip(@trip1)
      @passenger.add_trip(@trip2)
      @passenger.add_trip(@trip3)

      expect(@passenger.net_expenditures).must_equal 64.35
    end

    it "Ignores an in progress trip" do
      @passenger.add_trip(@trip4)
      expect(@passenger.net_expenditures).must_equal 0
    end
  end
  describe "total time spent" do

    it "total amount of time the passenger has spent on their trips" do
      @passenger.add_trip(@trip1)
      @passenger.add_trip(@trip2)
      expect(@passenger.total_time_spent).must_equal 20
    end

    it "must be a float" do
      @passenger.add_trip(@trip1)
      expect(@passenger.total_time_spent).must_be_instance_of Float
      expect(@passenger.total_time_spent).must_equal 10
    end

    it "Passenger has 0 trips" do
      expect(@passenger.total_time_spent).must_equal 0
    end
    it "Ignores an in progress trip" do
      @passenger.add_trip(@trip4)
      expect(@passenger.total_time_spent).must_equal 0
    end
  end
end

