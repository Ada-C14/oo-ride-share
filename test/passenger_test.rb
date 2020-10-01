# frozen_string_literal: true

require_relative 'test_helper'

describe 'Passenger class' do

  describe 'Passenger instantiation' do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: 'Smithy', phone_number: '353-533-5334')
    end

    it 'is an instance of Passenger' do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end

    it 'throws an argument error with a bad ID value' do
      expect do
        RideShare::Passenger.new(id: 0, name: 'Smithy', phone_number: '353-533-5334')
      end.must_raise ArgumentError
    end

    it 'sets trips to an empty array if not provided' do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end

    it 'is set up for specific attributes and data types' do
      %i[id name phone_number trips].each do |prop|# array of symbol
        expect(@passenger).must_respond_to prop
      end

      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end


  describe 'trips property' do
    before do
      # TODO: you'll need to add a driver in wave 2
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: 'Merl Glover III',
        phone_number: '1-602-620-2330 x3723',
        trips: []
        )
      @driver = RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE
      )
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

    it 'each item in array is a Trip instance' do
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

  describe 'net_expenditures' do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: 'Merl Glover III',
        phone_number: '1-602-620-2330 x3723',
        trips: []
      )
    end

    # let (:trip) do
    #   RideShare::Trip.new(
    #     id: 8,
    #     passenger: @passenger,
    #     start_time: Time.new(2016, 8, 8),
    #     end_time: Time.new(2016, 8, 9),
    #     rating: 5
    #   )
    # end
    it 'will return 0 if the passenger has no trip' do
      expect(@passenger.net_expenditures).must_equal 0
    end

    it 'will return the total amount of money of the passenger has spent on all trips' do
      trip1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 25,
        rating: 5,
        driver_id: RideShare::Driver.new(
          id: 2,
          name: "Tango",
          vin: "1C9EVBRM0YBC564DZ")
      )
      trip2 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 7, 7),
        end_time: Time.new(2016, 7, 8),
        cost: 15,
        rating: 5,
        driver_id: RideShare::Driver.new(
            id: 2,
            name: "Tango",
            vin: "1C9EVBRM0YBC564DZ")
      )

      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      expect(@passenger.net_expenditures).must_equal trip1.cost + trip2.cost

    end
  end

  describe 'total_time_spent' do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: 'Merl Glover III',
        phone_number: '1-602-620-2330 x3723',
        trips: []
      )
    end

    it 'will return 0 if the passenger has no trip' do
      expect(@passenger.total_time_spent).must_equal 0
    end

    it 'will return the total amount of time that passenger has spent on their trips' do
      @driver_id = RideShare::Driver.new(
          id: 2,
          name: "Tango",
          vin: "1C9EVBRM0YBC564DZ")

      trip1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 25,
        rating: 5,
      driver_id: @driver_id
      )
      trip2 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 7, 7),
        end_time: Time.new(2016, 7, 8),
        cost: 15,
        rating: 5,
        driver_id: @driver_id
      )

      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      expect(@passenger.total_time_spent).must_equal trip1.trip_duration + trip2.trip_duration
    end
  end
end
