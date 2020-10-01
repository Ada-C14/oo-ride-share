require 'csv'
require 'time'

require_relative './lib/trip'
require_relative './lib/trip_dispatcher'
require_relative './lib/passenger'

# Some example code illustrating the issues with our original test implementation

new_trip_dispatcher = RideShare::TripDispatcher.new
p new_trip_dispatcher
dup = new_trip_dispatcher.dup
before_length = new_trip_dispatcher.trips.length
before_array = new_trip_dispatcher.trips.dup
"\n"
p before_length
puts "\n"
puts new_trip_dispatcher.passengers[0].trips
puts "\n"

new_trip = new_trip_dispatcher.request_trip(1)
puts new_trip
puts "\n"
puts new_trip_dispatcher.passengers[0].trips
puts "\n"
p new_trip_dispatcher
puts new_trip_dispatcher.trips.length
puts before_length
p dup
puts "before array length: #{before_array.length}"
puts "after array length: #{new_trip_dispatcher.trips.length}"

puts "The duplicated array includes the new trip: #{before_array.include?(new_trip)}"