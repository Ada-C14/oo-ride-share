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
        rating: 5,
        driver: RideShare::Driver.new(
          id: 2,
          name: "Test",
          vin: "12345678901234567",
          status: :AVAILABLE
         )
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
  ################################################################################
  describe "net_expenditures" do
    # You add tests for the net_expenditures method
    it "total costs with no rides" do
      passenger = RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
      )
      expect(passenger.net_expenditures).must_equal 0
    end

    it "total cost calculates sum" do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      passenger = RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
      )
      trip_data = {
          id: 8,
          passenger: passenger,
          start_time: start_time,
          end_time: end_time,
          cost: 23.45,
          rating: 3,
          driver: RideShare::Driver.new(
          id: 2,
          name: "Test",
          vin: "12345678901234567",
          status: :AVAILABLE
      )
      }
      trip = RideShare::Trip.new(trip_data)
      trip_data2 = {
          id: 8,
          passenger: passenger,
          start_time: start_time,
          end_time: end_time,
          cost: 100.00,
          rating: 3,
          driver: RideShare::Driver.new(
              id: 3,
              name: "Test",
              vin: "12345678901234568",
              status: :AVAILABLE
          )
      }
      trip2 = RideShare::Trip.new(trip_data2)

      passenger.add_trip(trip)
      passenger.add_trip(trip2)

      expect(passenger.net_expenditures).must_equal 123.45
    end

  end

  describe "total_time_spent" do
    it "total time with no trips" do
      passenger = RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
      )
      expect(passenger.total_time_spent).must_equal 0
    end

    it "total time calculates sum" do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      passenger = RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
      )
      trip_data = {
          id: 8,
          passenger: passenger,
          start_time: start_time,
          end_time: end_time,
          cost: 23.45,
          rating: 3,
          driver: RideShare::Driver.new(
              id: 2,
              name: "Test",
              vin: "12345678901234567",
              status: :AVAILABLE
          )
      }
      trip = RideShare::Trip.new(trip_data)
      trip_data2 = {
          id: 8,
          passenger: passenger,
          start_time: start_time,
          end_time: end_time,
          cost: 100.00,
          rating: 3,
          driver: RideShare::Driver.new(
              id: 1,
              name: "Test",
              vin: "12345678901234568",
              status: :AVAILABLE
          )
      }
      trip2 = RideShare::Trip.new(trip_data2)

      passenger.add_trip(trip)
      passenger.add_trip(trip2)

      expect(passenger.total_time_spent).must_equal 50*60
    end
  end
end
