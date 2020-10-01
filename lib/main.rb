require_relative 'passenger'
require_relative 'trip'
require_relative 'csv_record'

passenger1 = Passenger.new(2, "Merten Noles", 8347387434, [1,20,54,2018-12-27 02:39:05 -0800,2018-12-27 03:38:08 -0800,10,4])

passenger1_expenditures = passenger1.net_expenditures

pp passenger1_expenditures

arr = [5,6,1]

arr_sum = arr.reduce(:+)

pp arr_sum

@trips =

def net_expenditures
  array_trip_costs = @trips.map(&:cost)
  total_expenditure = array_trip_costs.reduce(:+)
  return total_expenditure
end