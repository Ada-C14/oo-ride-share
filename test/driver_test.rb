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
      @rated_driver = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ"
      )
      trip = RideShare::Trip.new(
        id: 8,
        driver: @rated_driver,
        passenger_id: 3,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 8),
        rating: 5
      )
      @rated_driver.add_trip(trip)
    end

    it "returns a float" do
      expect(@rated_driver.average_rating).must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @rated_driver.average_rating
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
        driver: @rated_driver,
        passenger_id: 3,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 1
      )
      @rated_driver.add_trip(trip2)

      expect(@rated_driver.average_rating).must_be_close_to (5.0 + 1.0) / 2.0, 0.01
    end

    it "ignores in progress trips" do
      start_rating = @rated_driver.average_rating

      trip22 = RideShare::Trip.new(
          id: 8,
          driver: @rated_driver,
          passenger_id: 3,
          start_time: Time.now,
          end_time: nil,
          rating: nil
      )
      @rated_driver.assign_new_trip(trip22)

      expect(@rated_driver.average_rating).must_equal start_rating

    end
  end

  describe "total_revenue" do
    before do
      @inactive_driver = RideShare::Driver.new(
          id: 100,
          name: "Sad Dan",
          vin: "12345678901234567"
      )

      @busy_driver = RideShare::Driver.new(
          id: 40,
          name: "Spartacus",
          vin: "18293856382910583"
      )

      trip1 = RideShare::Trip.new(
          id: 20,
          driver_id: 40,
          passenger_id: 30,
          start_time: Time.new(2020, 7, 7, 5, 15),
          end_time: Time.new(2020, 7, 7, 5, 45),
          cost: 26,
          rating: 3
      )
      trip2 = RideShare::Trip.new(
          id: 50,
          driver_id: 40,
          passenger_id: 39,
          start_time: Time.new(2020, 6, 7, 2, 30),
          end_time: Time.new(2020, 6, 7, 3, 30),
          cost: 42,
          rating: 4
      )
      trip3 = RideShare::Trip.new(
          id: 89,
          driver_id: 40,
          passenger_id: 206,
          start_time: Time.new(2020, 9, 7, 8, 45),
          end_time: Time.new(2020, 9, 7, 9, 30),
          cost: 17,
          rating: 2
      )

      @busy_driver.add_trip(trip1)
      @busy_driver.add_trip(trip2)
      @busy_driver.add_trip(trip3)
    end

    it "returns zero if driver has no trips" do
      expect(@inactive_driver.total_revenue).must_equal 0
    end

    it "doesn't take fee out of trips less than $1.65" do
      cheap_trip = RideShare::Trip.new(
          id: 12,
          passenger_id: 12,
          start_time: Time.new(2020, 8, 8, 9, 12),
          end_time: Time.new(2020, 8, 8, 9, 14),
          cost: 1.00,
          rating: 5,
          driver_id: 100
      )
      @inactive_driver.add_trip(cheap_trip)

      expect(@inactive_driver.total_revenue).must_equal 0.80
    end

    it "calculates the correct revenue" do
      expect(@busy_driver.total_revenue).must_equal 64.04
    end

    it "ignore in progress trips" do
      current_revenue = @busy_driver.total_revenue

      trip4 = RideShare::Trip.new(
          id: 89,
          driver_id: 40,
          passenger_id: 206,
          start_time: Time.now,
          end_time: nil,
          cost: nil,
          rating: nil
      )
      @busy_driver.add_trip(trip4)

      expect(@busy_driver.total_revenue).must_equal current_revenue
    end
  end

  describe "assign_new_trip" do
    before do
      @assigned_driver = RideShare::Driver.new(
          id: 40,
          name: "Spartacus",
          vin: "18293856382910583"
      )

      trip11 = RideShare::Trip.new(
          id: 20,
          driver_id: 40,
          passenger_id: 30,
          start_time: Time.new(2020, 7, 7, 5, 15),
          end_time: Time.new(2020, 7, 7, 5, 45),
          cost: 26,
          rating: 3
      )
      trip12 = RideShare::Trip.new(
          id: 50,
          driver_id: 40,
          passenger_id: 39,
          start_time: Time.new(2020, 6, 7, 2, 30),
          end_time: Time.new(2020, 6, 7, 3, 30),
          cost: 42,
          rating: 4
      )
      @trip13 = RideShare::Trip.new(
          id: 89,
          driver_id: 40,
          passenger_id: 206,
          start_time: Time.new(2020, 9, 7, 8, 45),
          end_time: Time.new(2020, 9, 7, 9, 30),
          cost: 17,
          rating: 2
      )

      @assigned_driver.add_trip(trip11)
      @assigned_driver.add_trip(trip12)
    end
   
    it "adds in progress trip to driver's trips array" do
      start_length = @assigned_driver.trips.length

      expect(@assigned_driver.trips).wont_include @trip13

      @assigned_driver.assign_new_trip(@trip13)

      expect(@assigned_driver.trips.length).must_equal start_length + 1
      expect(@assigned_driver.trips).must_include @trip13
    end

    it "changes driver status to unavailable" do
      expect(@assigned_driver.status.to_sym).must_equal :AVAILABLE
      
      @assigned_driver.assign_new_trip(@trip13)

      expect(@assigned_driver.status.to_sym).must_equal :UNAVAILABLE
    end
  end
end
