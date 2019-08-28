def request_trip(passenger_id)
  trip = Trip.new(...startTime=time.now)

  driver.add_trip(trip)
  passenger = Passenger.find_by_id(passenger_id)
  passenger.add_trip(trip)