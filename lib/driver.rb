require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE , trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips


      unless @vin.size == 17
        raise ArgumentError.new("#{@vin} is not the right size")
      end

      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise ArgumentError.new("Invalid status")
      end

      # until [:AVAILABLE, :UNAVAILABLE].include?(@status)
      #   raise ArgumentError.new("Invalid status")
      # end

    end

    private

    def self.from_csv(record)
      return self.new(
          id: record[:id],
          name: record[:name],
          vin: record[:vin],
          status: record[:status].to_sym)
    end
  end
end
