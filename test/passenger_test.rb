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
          id: 1,
          name: "Bob Bobston",
          vin: "WBS76FYD47DJF7206")
      trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
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

  describe "net_expenditures" do # check accurate return of total amount of money that passenger has spent on their trips
    before do
      @passenger = RideShare::Passenger.new(id: 3, name: "Sammy", phone_number: "353-076-5334")
      @driver = RideShare::Driver.new(id: 1, name: "Bob Bobston", vin: "WBS76FYD47DJF7206")
      @trip1 = RideShare::Trip.new(
          id: 8,
          driver: @driver,
          passenger: @passenger,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          rating: 5,
          cost: 14
      )
      @trip2 = RideShare::Trip.new(
          id: 9,
          driver: @driver,
          passenger: @passenger,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          rating: 5,
          cost: 10
      )
      end

    it "returns accurate net_expenditures" do
      @passenger.add_trip(@trip1)
      total_cost = @passenger.net_expenditures
      expect(total_cost).must_equal 14


      @passenger.add_trip(@trip2)
      total_cost = @passenger.net_expenditures
      expect(total_cost).must_equal 24
    end

    it "does not include expenditures from trips in progress (values will be nil)" do
      trip_in_progress = RideShare::Trip.new(
          id: 3,
          driver: @driver,
          passenger: @passenger,
          start_time: Time.now,
          end_time: nil,
          rating: nil,
          cost: nil
      )

      @passenger.add_trip(@trip1)
      @passenger.add_trip(@trip2)
      @passenger.add_trip(trip_in_progress)

      total_cost = @passenger.net_expenditures

      expect(total_cost).must_equal 24
    end

    it "returns 0 if passenger has no trips" do
      expect(@passenger.net_expenditures).must_equal 0
    end
  end

  describe "total_time_spent" do
    before do
      @passenger = RideShare::Passenger.new(id: 3, name: "Sammy", phone_number: "353-076-5334")
      @driver = RideShare::Driver.new(id: 1, name: "Bob Bobston", vin: "WBS76FYD47DJF7206")

      start_time = Time.now - 60 * 60
      end_time = start_time + 25 * 60
      @trip1 = RideShare::Trip.new(
          id: 8,
          driver: @driver,
          passenger: @passenger,
          start_time: start_time,
          end_time: end_time,
          rating: 5,
          cost: 14
      )

      start_time2 = Time.now - 60 * 60
      end_time2 = start_time + 10 * 60
      @trip2 = RideShare::Trip.new(
          id: 9,
          driver: @driver,
          passenger: @passenger,
          start_time: start_time2,
          end_time: end_time2,
          rating: 5,
          cost: 10
      )
    end

    it "returns total amount of time passenger has spent on trips" do

      @passenger.add_trip(@trip1)
      @passenger.add_trip(@trip2)

      total_time = @passenger.total_time_spent

      expect(total_time).must_be_close_to 2100.0
    end

    it "does not include duration of trips in progress (values will be nil)" do
      trip_in_progress = RideShare::Trip.new(
          id: 3,
          driver: @driver,
          passenger: @passenger,
          start_time: Time.now,
          end_time: nil,
          rating: nil,
          cost: nil
      )

      @passenger.add_trip(@trip1)
      @passenger.add_trip(@trip2)
      @passenger.add_trip(trip_in_progress)

      total_time = @passenger.total_time_spent

      expect(total_time).must_be_close_to 2100.0
    end

    it "returns 0 if passenger has no trips" do
      expect(@passenger.total_time_spent).must_equal 0
    end
  end
end
