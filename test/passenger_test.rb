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
      @driver = RideShare::Driver.new(
        id: 2,
        name: "Chris",
        vin: "1B6CF40K1J3Y74UY2",
        status: :AVAILABLE,
        trips: []
        )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 10.5,
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

  describe "net_expenditures" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
          id: 9,
          name: "Merl Glover III",
          phone_number: "1-602-620-2330 x3723",
          trips: []
      )
      @driver = RideShare::Driver.new(
        id: 2,
        name: "Chris",
        vin: "1B6CF40K1J3Y74UY2",
        status: :AVAILABLE,
        trips: []
        )
      trip = RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          driver: @driver,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          cost: 10.5,
          rating: 5
      )
      trip_2 = RideShare::Trip.new(
          id: 9,
          passenger: @passenger,
          driver: @driver,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          cost: 9,
          rating: 5
      )

      @passenger.add_trip(trip)
      @passenger.add_trip(trip_2)
    end

    it "can calculate the total spending for each passenger" do
        expect(@passenger.net_expenditures).must_equal 19.5
    end

    it "can calculate total spending for a passenger with a trip in-progress" do
      trip_3 = RideShare::Trip.new(
          id: 10,
          passenger: @passenger,
          driver: @driver,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
      )
      @passenger.add_trip(trip_3)
      expect(@passenger.net_expenditures).must_equal 19.5
    end

  end

  describe "total_time_spent" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
          id: 9,
          name: "Merl Glover III",
          phone_number: "1-602-620-2330 x3723",
          trips: []
      )
      @driver = RideShare::Driver.new(
        id: 2,
        name: "Chris",
        vin: "1B6CF40K1J3Y74UY2",
        status: :AVAILABLE,
        trips: []
        )
      trip = RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          driver: @driver,
          start_time: Time.parse("2018-12-27 01:39:05 -0800"),
          end_time: Time.parse("2018-12-27 02:39:05 -0800"),
          cost: 10.5,
          rating: 5
      )
      trip_2 = RideShare::Trip.new(
          id: 9,
          passenger: @passenger,
          driver: @driver,
          start_time: Time.parse("2018-12-27 01:39:05 -0800"),
          end_time: Time.parse("2018-12-27 01:59:05 -0800"),
          cost: 9,
          rating: 5
      )

      @passenger.add_trip(trip)
      @passenger.add_trip(trip_2)
    end

    it "can calculate the total time spent for each passenger" do
      expect(@passenger.total_time_spent).must_equal 4800
    end

    it "can calculate total time spent for a passenger with a trip in-progress" do
      trip_3 = RideShare::Trip.new(
          id: 10,
          passenger: @passenger,
          driver: @driver,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
      )
      @passenger.add_trip(trip_3)
      expect(@passenger.total_time_spent).must_equal 4800
    end

  end

end
