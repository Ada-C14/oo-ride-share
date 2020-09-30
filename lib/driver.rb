module RideShare
  class Driver < CsvRecord

    VALID_STATUS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status:, trips: [])
      super(id)
      @name = name
      @vin = vin
      @status = status
      @trips = trips


      unless @vin.length == 17
        raise ArgumentError, "Invalid vehicle identification number"
      end
    end
  end
end