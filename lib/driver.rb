require_relative 'trip_dispatcher'
require_relative 'csv_record'

module Rideshare
  class Driver < CsvRecord

    attr_reader

    def initialize(id:, name:, vin:, status:, trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips
    end


    private

    def self.from_csv(record)
      return new(
          id: record[:id],
          name: record[:name],
          vin: record[:vin],
          status: record[:status],

      )
    end

    #.from_csv for trip class:
    # def self.from_csv(record)
    #   return self.new(
    #       id: record[:id],
    #       passenger_id: record[:passenger_id],
    #       start_time: Time.parse(record[:start_time]), #"2019-01-24 21:36:19 -0800"
    #       end_time: Time.parse(record[:end_time]),
    #       cost: record[:cost],
    #       rating: record[:rating]
    #   )
    # end

  end
end

