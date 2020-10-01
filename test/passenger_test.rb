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
        RideShare::Passenger.new(id: 0, name: "Smithy",phone_number: "353-533-5334" )
      end.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end

    # pay attention to this test. Testing if the attributes work and that's its the data type that we want
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
        # added driver here
        driver_id: 3,
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
    # pay attention to this test
    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end


  describe "net_expenditures" do
    # You add tests for the net_expenditures method
    before do
      # TODO: you'll need to add a driver at some point here.
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
          start_time: Time.new(2016, 8, 8), # => 2016-08-08 00:00:00 -0500
          end_time: Time.new(2016, 8, 9),
          rating: 5,
          cost: 15
      )

      @trip_2 = RideShare::Trip.new(
          id: 9,
          passenger: @passenger,
          driver_id: 4,
          start_time: Time.new(2016, 10, 8),
          end_time: Time.new(2016, 10, 9),
          rating: 4,
          cost: 10
      )

      # @passenger.add_trip(trip)
      # @passenger.add_trip(trip_2)
      # there are two trips in the passenger instance now
    end

    it "returns the accurate cost " do
      #arrange
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_2)
      passenger_total_cost = @passenger.net_expenditures

      #act and assert
      expect(passenger_total_cost).must_equal 25
    end

    it "returns zero when passenger took no trips " do
      passenger_total_cost = @passenger.net_expenditures

      expect(passenger_total_cost).must_equal 0
    end

    #wave 3 added tests to ignore in-progress trips
    it "ignores in-progress trips" do
      #arrange
      new_trip = RideShare::Trip.new(
          # what should the id of this trip be?
          id: 25,
          passenger: @passenger,
          passenger_id: @passenger.id,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil,
          driver_id: 4,
      )
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(new_trip)

      #act and assert
      expect(@passenger.net_expenditures).must_equal 15

    end
  end

  describe "total_time_spent" do
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
        driver_id: 2,
        start_time: Time.new(2016, 8, 9, 4, 20), # => 2016-08-09 04:20:00 -0500
        end_time: Time.new(2016, 8, 9, 4, 30), #=> 600 seconds
        rating: 5,
        cost: 15
    )

    @trip_2 = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        driver_id: 3,
        start_time: Time.new(2016, 10, 8, 10, 15),
        end_time: Time.new(2016, 10, 8, 10, 20), #=> 5 minutes, or 300 seconds
        rating: 4,
        cost: 10
    )
    end

    it "returns the total duration of passenger spent of their trips" do
      # arrange
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(@trip_2)

      # act
      passenger_total_duration = @passenger.total_time_spent
      #assert
      expect(passenger_total_duration).must_equal 900

    end

    it "returns zero when passenger took no trips " do
      passenger_total_duration = @passenger.total_time_spent

      expect(passenger_total_duration).must_equal 0

    end

    #wave 3
    it "ignores in-progress trips" do
      new_trip = RideShare::Trip.new(
          id: 25,
          passenger: @passenger,
          passenger_id: @passenger.id,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil,
          driver_id: 4,
          )
      @passenger.add_trip(@trip_1)
      @passenger.add_trip(new_trip)

      expect(@passenger.total_time_spent).must_equal 600

    end

  end
end
