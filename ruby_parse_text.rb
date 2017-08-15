#!/usr/bin/env ruby
#
# Filename:    ruby_parse_text.rb
# 
# Description: Simple script to take a text file and parse out the drivers,
#              their trips, and the determine drive length + average speed;
#              for the purpose of generating a report and dumping it to
#              stdout
#

require 'trollop'
require './ruby_parse_funcs'


#
# Handle program options
#
OPTIONS = Trollop::options do
  banner <<-EOS
Usage:
   ruby_parse_text input.txt
EOS
end


#
# Use a given filename to populate a table from the given file
#
def handleInput(filename)

  # variable to store the file string contents
  contents = []

  # open the file, read-only
  f = File.open(filename, 'r')

  # get the file contents
  f.each_line do |line|

      # strip each line for whitespace and append each line to the
      # contents array
      contents.push(line.rstrip)
  end

  # using the line contents, attempt to obtain a list of the drivers
  drivers = obtainDrivers(contents)

  # using the line contents, attempt to obtain the trip data
  trips = obtainTrips(contents)

  # using the drivers and the trip data, generate the requested report
  result = generateReport(drivers, trips)

  #
  # dump the result to stdout
  #
  if result.length < 1
      puts "No drivers recorded at this time."
  else
      puts result
  end
end


#
# PROGRAM MAIN
#

Trollop.die "Missing input file argument" unless ARGV.count > 0
until ARGV.empty? do
  file = ARGV.shift
  File.exists?(file) or Trollop.die "Invalid file: #{file}"
  handleInput(file)
end
