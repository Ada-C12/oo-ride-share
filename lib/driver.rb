# Wave 2

# Attr_????
# class Driver
# inherits from CsvRecord (similar to Trip & Passenger)

#def initialize(:id,:name,:vin,:status,:trips)
# super(id)

#:id, unique number for this driver
# Pass to the superclass constructor (CsvRecord) similar to Passenger

#:name, driver's name

#:vin, driver's VIN
# String length of 17. Raise ArgumentError if it's wrong length.

#:status, Is this Driver available to drive?
# Must be one of :available or :unavailable

#:trips, A list of trips this driver has driven
# Optional, if not provided, initialize to an empty array (similar to Passenger)
# @trips = trips || []

#def self.from_csv()
# Driver.load_all
#end