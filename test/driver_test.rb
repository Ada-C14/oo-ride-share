require_relative 'test_helper'

describe "Driver class" do
  describe "Driver instantiation" do
    before do
      @driver = RideShare::Driver.new(
        id: 54,
        name: "Test Driver",
        vin: "12345678901234567",
        status: :AVAILABLE
      )
    end

    it "is an instance of Driver" do
      expect(@driver).must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad ID" do
      expect { RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133") }.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      expect { RideShare::Driver.new(id: 100, name: "George", vin: "") }.must_raise ArgumentError
      expect { RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums") }.must_raise ArgumentError
    end

    it "has a default status of :AVAILABLE" do
      expect(RideShare::Driver.new(id: 100, name: "George", vin: "12345678901234567").status).must_equal :AVAILABLE
    end

    it "sets driven trips to an empty array if not provided" do
      expect(@driver.trips).must_be_kind_of Array
      expect(@driver.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :vin, :status, :trips].each do |prop|
        expect(@driver).must_respond_to prop
      end

      expect(@driver.id).must_be_kind_of Integer
      expect(@driver.name).must_be_kind_of String
      expect(@driver.vin).must_be_kind_of String
      expect(@driver.status).must_be_kind_of Symbol
    end
  end

  describe "add_trip method" do
    before do
      pass = RideShare::Passenger.new(
        id: 1,
        name: "Test Passenger",
        phone_number: "412-432-7640"
      )
      @driver = RideShare::Driver.new(
        id: 3,
        name: "Test Driver",
        vin: "12345678912345678"
      )
      @trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: pass,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2018, 8, 9),
        rating: 5
      )
    end

    it "adds the trip" do
      expect(@driver.trips).wont_include @trip
      previous = @driver.trips.length

      @driver.add_trip(@trip)

      expect(@driver.trips).must_include @trip
      expect(@driver.trips.length).must_equal previous + 1
    end
  end

  describe "average_rating method" do
    before do
      @driver = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ"
      )
      trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger_id: 3,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 8),
        rating: 5
      )
      @driver.add_trip(trip)
    end

    it "returns a float" do
      expect(@driver.average_rating).must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      expect(average).must_be :>=, 1.0
      expect(average).must_be :<=, 5.0
    end

    it "returns zero if no driven trips" do
      driver = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ"
      )
      expect(driver.average_rating).must_equal 0
    end

    it "correctly calculates the average rating" do
      trip2 = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger_id: 3,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 1
      )
      @driver.add_trip(trip2)

      expect(@driver.average_rating).must_be_close_to (5.0 + 1.0) / 2.0, 0.01
    end
  end

  describe "total_revenue" do
    # You add tests for the total_revenue method
    before do
      @driver = RideShare::Driver.new(
          id: 54,
          name: "Rogers Bartell IV",
          vin: "1C9EVBRM0YBC564DZ"
      )
    end

    it "returns correct total revenue" do
      trip_1 = RideShare::Trip.new(
          id: 8,
          driver: @driver,
          passenger_id: 3,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 8),
          cost: 10,
          rating: 5
      )

      trip2 = RideShare::Trip.new(
          id: 8,
          driver: @driver,
          passenger_id: 3,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          cost: 5,
          rating: 1
      )

      @driver.add_trip(trip_1)
      @driver.add_trip(trip2)

      expect(@driver.total_revenue).must_equal 9.36
    end

    it "returns 0 total_revenue for 0 trips" do
      expect(@driver.total_revenue).must_equal 0
    end

    it "returns 0 if cost of trip was less than $1.65" do
      trip_3 = RideShare::Trip.new(
          id: 8,
          driver: @driver,
          passenger_id: 3,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 8),
          cost: 1.00,
          rating: 5
      )

      @driver.add_trip(trip_3)

      expect(@driver.total_revenue).must_equal 0
    end
  end

  describe "start_trip method" do
    before do
      @driver_1 = RideShare::Driver.new(
          id: 25,
          name: "Bob Belcher",
          vin: "1C9EVBRM0YBC564DZ",
      )

      @driver_2 = RideShare::Driver.new(
          id: 30,
          name: "Jimmy Pesto",
          vin: "10YBC564DZC9EVBRM",
          status: :UNAVAILABLE
      )
    end


    it 'properly updates the drivers status' do
      trip = RideShare::Trip.new(
          id: 8,
          driver: @driver_1,
          passenger_id: 3,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
      )

      @driver_1.start_trip(trip)

      expect(@driver_1.status).must_equal :UNAVAILABLE
      expect(@driver_1.trips[0]).must_be_instance_of RideShare::Trip
      expect(@driver_1.trips[0]).must_equal trip
    end

    it 'throws an error if driver is unavailable' do
      trip = RideShare::Trip.new(
          id: 8,
          driver: @driver_2,
          passenger_id: 3,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
      )

      expect{ @driver_2.start_trip(trip) }.must_raise ArgumentError
    end
  end
end
