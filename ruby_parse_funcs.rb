#!/usr/bin/env ruby
#
# Filename:    ruby_parse_driver_funcs.rb
# 
# Description: Functions to assist in parsing and verifying the input
#              file contents for ruby_parse_text.rb
#


#
# Extract a list of drivers from the input file contents
#
# @input    string[]    input file contents, line-by-line
#
# @output   string[]    list of drivers
#
def obtainDrivers(contents)

    # variable to hold the list of drivers
    drivers = []

    # for every line...
    contents.each do |line|

        # use regex to ensure the line matches the expected
        captures = /^Driver ([A-Za-z]{1,64})$/.match(line)

        # safety check, ensure the capture isn't nil
        if captures.nil?
            next
        end

        # if the regex capture has a length of at least one,
        # push it to the list of drivers
        if captures.length > 0
            drivers.push(captures[1])
        end
    end

    # return the list drivers
    return drivers
end


#
# Extract a list of trips from the input file contents
#
# @input    string[]    input file contents, line-by-line
#
# @output   Trip        list of trips
#
#
# Note: where the 'Trip' object has the following definition:
#
# :driver        => name of driver
# :start_time    => starting trip time
# :end_time      => ending trip time
# :average_speed => average speed during trip, in mph
# :miles_driven  => miles driven on this trip
#
def obtainTrips(contents)

    # variable to hold the list of trips
    trips = []

    # for every line...
    contents.each do |line|

        # use regex to ensure the line matches
        captures = /^Trip ([A-Za-z]{1,64}) ([0-2]\d):(\d\d) ([0-2]\d):(\d\d) (\d{1,3}\.?\d?)$/.match(line)

        # safety check, ensure the capture isn't nil
        if captures.nil?
            next
        end

        # if the regex capture has a length of at least 6:
        #
        # * driver
        # * start time - HH
        # * start time - MM
        # * end time - HH
        # * end time - MM
        # * average speed 
        #
        if captures.length < 6
            next
        end

        # safety check, ensure this actually resembles a 24 hour clock
        if captures[2].to_i > 23 || captures[4].to_i > 23 ||
           captures[3].to_i > 59 || captures[5].to_i > 59
            next
        end

        # Obtain the current time
        t = Time.now

        # Assemble a start time
        start_time = Time.local(t.year, t.day, t.month, captures[2], captures[3])

        # Assemble an end time
        end_time = Time.local(t.year, t.day, t.month, captures[4], captures[5])

        # Throw a warning if the start time is *after* the end time,
        # but skip on to the next element...
        if start_time > end_time
            puts "\nWarning: Improper start / end time detected!"
            puts "--------------------------------------------"
            puts line
            puts "--------------------------------------------\n"
            next
        end

        # assemble the trip array
        trip = {:driver        => captures[1],
                :start_time    => start_time,
                :end_time      => end_time,
                :average_speed => 0,
                :miles_driven  => captures[6].to_f}

        # attempt to calculate the average speed
        start_minutes = (captures[2].to_i * 60) + captures[3].to_i
        end_minutes   = (captures[4].to_i * 60) + captures[5].to_i
        total_time_in_minutes = end_minutes - start_minutes
        if total_time_in_minutes <= 0
            next
        end
        trip[:average_speed] = trip[:miles_driven] * 60 / total_time_in_minutes

        # discard trips with speed < 5mph or speed > 100mph
        if trip[:average_speed] < 5 || trip[:average_speed] > 100
            next
        end

        # add the trip to the list of trips
        trips.push(trip)
    end

    # send back the list of trips
    return trips
end


#
# Generate the report from the drivers and trips
#
# @input    string[]    list of drivers
# @input    string[]    list of trips
#
# @output   string      generated output
#
def generateReport(drivers, trips)

    # variable to hold the generated string output, and the total amount
    # for each driver
    output = ""
    array_of_mileages = []

    #
    # Calculate the total miles driven and average of each driver
    #

    # for every driver...
    drivers.each do |driver|

        # trip counter variable
        count = 0

        # assemble a milage object
        mileage = {:driver        => driver,
                   :total_miles   => 0,
                   :average_speed => 0}

        # for every trip...
        trips.each do |trip|

            # skip to the next trip if it doesn't involve this driver
            if trip[:driver] != mileage[:driver]
                next
            end

            # add the current number of miles to the total miles driven
            mileage[:total_miles] += trip[:miles_driven]
            mileage[:average_speed] += trip[:average_speed]

            # increment the count
            count += 1
        end

        # calculate the average speed
        if count > 0
            mileage[:average_speed] = mileage[:average_speed] / count
        end

        # push the driver mileage object to the array
        array_of_mileages.push(mileage)
    end

    #
    # Assemble the string output of the report
    #

    # Sort the array by the 'total miles' each driver has driven, descending
    array_of_mileages.sort_by! { |a| a[:total_miles] }
    array_of_mileages = array_of_mileages.reverse

    # for every driver...
    array_of_mileages.each do |per_driver|

        # append the name
        output += per_driver[:driver] + ": "

        # print the miles and average, if greater than zero
        if per_driver[:total_miles] > 0
            output += (per_driver[:total_miles].round(0)).to_s + " miles @ "
            output += (per_driver[:average_speed].round(0)).to_s + "mph\n"
        else
            output += "0 miles\n"
        end
    end

    # send back the completed string
    return output
end
