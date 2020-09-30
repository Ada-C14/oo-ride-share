module RideShare
  class Driver < CsvRecord

    VALID_STATUS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status:, trips: [])
      super(id)
      @name = name
      @vin = vin
      @status = status
      @trips = trips


    end
  end
end