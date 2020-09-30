require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord

    def initialize(id: , name: , vin: , status:, trips:[])
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips

    end
  end
end