# Ruby Text Parser 

This is a simple script that reads in data from text files, with the
ability to register drivers and calculate trip data. It is recommended you
read the contents of this file to fully setup the new app.


# Project Notes

a) Script uses a simple commandline arg for the ruby_parse_text.rb input
   text file, see the "Running" section at the end of this document.

b) Tests for the various functions are located in ruby_parse_tests.rb,
   which can be ran in the manner described in the "Running" section at the
   end of this document.

c) The functions needed for this program are in the
   ruby_parse_funcs.rb file. This is to both make the main script
   easier to read / edit, but also to allow for testing separately.

d) One of the functions, obtainTrips(), returns objects of type 'Trip'
   which contain the following definition:

   Trip {

    :driver        => name of driver
    :start_time    => starting trip time
    :end_time      => ending trip time
    :average_speed => average speed during trip, in mph
    :miles_driven  => miles driven on this trip

   }

   This is done so that the data gather can be easily used alongside the
   generateReport() function.

e) Reports generated are in the form of strings and dumped to stdout.


# Requirements

Specifically, the following rubygems are required:

* trollop

Recommend running this on Linux as it has not been tested for other
platforms. Specifically, it was created on a Ubuntu 16.04 image via
docker.

Feel free to email me if this does not appear to work on your platform,
ideally with the error message in question or a strong idea of what the
problem might be.


# Usage

To register a driver with the system, add the following line to the input
text file:

    Driver %name

Where %name is the name of the driver you wish to add. If you wish to
record a driver's trip with the system, use the following format:

    Trip %name %start %end %miles_traveled

Where %name is the name of the driver, %start / %end is the 24 hour clock
time, and %miles_traveled is the distance traveled in miles on this
particular trip.

An example text file in this format would look like:

    Driver Dan
    Driver Alex
    Driver Bob
    Trip Dan 07:15 07:45 17.3
    Trip Dan 06:12 06:32 21.8
    Trip Alex 12:01 13:16 42.0

Please note that the script is programmed to ignore all other poorly
formatted lines; and will throw warnings if the start time is after
the end time.

Afterwards this will output something like:

    Alex: 42 miles @ 34 mph
    Dan: 39 miles @ 50 mph
    Bob: 0 miles

Note that trips with zero miles traveled or trips that exceed an average
speed of less than 5mph or greater than 100mph will be ignored.


# Running

1) Run the program as follows, where input.txt is the input file:

    `ruby ruby_parse_text.rb input.txt`

2) Run the tests as follows:

    `ruby ruby_parse_tests.rb input.txt`


# Author

Written by Robert Bisewski. For more information, contact:

* Website -> www.ibiscybernetics.com

* Email -> contact@ibiscybernetics.com
