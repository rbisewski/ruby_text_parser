#!/usr/bin/env ruby
#
# Filename: ruby_parse_tests.rb
# 
# Description: Straightforward script to test the functions in the
#              ruby_parse_funcs.rb
#

require 'trollop'
require './ruby_parse_funcs'


#
# Handle program options
#
OPTIONS = Trollop::options do
  banner <<-EOS
Usage:
   ruby_parse_tests.rb
EOS
end


#
# PROGRAM MAIN
#

puts "Testing functions..."

# testing data with 3 correctly labelled drivers and 1 false
driver_data = ["Driver Adam",
               "Driver Tim",
               "dRjfs Fake",
               "Driver Bob",
               "Driver Zero"]

# attempt to obtain a list of drivers
puts "obtainDrivers() testing..."
drivers = obtainDrivers(driver_data)

# break if exactly 4 drivers are not detected
if drivers.length != 4
    puts "obtainDrivers() function has failed"
    exit
end
puts "obtainDrivers() function success"

# testing data with 5 valid trips and 2 invalid
trip_data = ["Trip Adam 07:15 07:55 27.1",
             "Trip Tim 09:05 12:45 77.3",
             "Trip Tim 11:10 17:45 281.9",
             "Trip Abcd -7+11 07.45 1783",
             "Trip Bob 04:15 06:45 95.7",
             "Trip Bob 09:15 11:45 81.7",
             "Trip Ffff p0:00 0q:00 0.0"]

# attempt to obtain a list of trips
puts "obtainTrips() testing..."
trips = obtainTrips(trip_data)

# break if exactly 5 trips are not detected
if trips.length != 5
    puts "obtainTrips() function has failed"
    exit
end
puts "obtainTrips() function success"

# attempt to generate a report using the drivers and trips
report_as_string = generateReport(drivers, trips)

# break if the empty string
if report_as_string.nil?
    puts "generateReport() function has failed"
    exit
end
puts "generateReport() function success"

# print out the report
puts report_as_string

# tell the end user all tests have failed
puts "all tests completed successful"
