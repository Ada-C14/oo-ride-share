require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: []) # to check if an error rais
      super(id)

      @name = name

      unless vin.to_s.length == 17
        raise ArgumentError, "VIN must be a string of length 17" # to check if raises an error
      end
      @vin = vin

      @status = status # to check
      @trips = trips

      availability = [:AVAILABLE, :UNAVAILABLE]
      unless availability.include?(@status)
        raise ArgumentError, "invalid driver availability"
      end
    end

  end
end


