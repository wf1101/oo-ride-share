require_relative 'spec_helper'

describe "TripDispatcher class" do
  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = RideShare::TripDispatcher.new
      [:trips, :passengers, :drivers].each do |prop|
        dispatcher.must_respond_to prop
      end

      dispatcher.trips.must_be_kind_of Array
      dispatcher.passengers.must_be_kind_of Array
      dispatcher.drivers.must_be_kind_of Array
    end
  end

  describe "find_driver method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      driver = @dispatcher.find_driver(2)
      driver.must_be_kind_of RideShare::Driver
    end
  end

  describe "find_passenger method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "finds a passenger instance" do
      passenger = @dispatcher.find_passenger(2)
      passenger.must_be_kind_of RideShare::Passenger
    end
  end

  describe "loader methods" do
    it "accurately loads driver information into drivers array" do
      dispatcher = RideShare::TripDispatcher.new

      first_driver = dispatcher.drivers.first
      last_driver = dispatcher.drivers.last

      first_driver.name.must_equal "Bernardo Prosacco"
      first_driver.id.must_equal 1
      first_driver.status.must_equal :UNAVAILABLE
      last_driver.name.must_equal "Minnie Dach"
      last_driver.id.must_equal 100
      last_driver.status.must_equal :AVAILABLE
    end

    it "accurately loads passenger information into passengers array" do
      dispatcher = RideShare::TripDispatcher.new

      first_passenger = dispatcher.passengers.first
      last_passenger = dispatcher.passengers.last

      first_passenger.name.must_equal "Nina Hintz Sr."
      first_passenger.id.must_equal 1
      last_passenger.name.must_equal "Miss Isom Gleason"
      last_passenger.id.must_equal 300
    end

    it "accurately loads trip info and associates trips with drivers and passengers" do
      dispatcher = RideShare::TripDispatcher.new

      trip = dispatcher.trips.first
      driver = trip.driver
      passenger = trip.passenger

      driver.must_be_instance_of RideShare::Driver
      driver.trips.must_include trip
      passenger.must_be_instance_of RideShare::Passenger
      passenger.trips.must_include trip
    end
  end

  describe "request_trip method" do
    it "can create a new trip requested by a passenger" do
      passenger_id = 10
      trip_dispatcher =  RideShare::TripDispatcher.new
      trip_dispatcher.request_trip(passenger_id).must_be_instance_of RideShare::Trip
    end

    it "return an updated trip collections including the new trip in passenger class" do
      passenger_id = 10
      trip_dispatcher = RideShare::TripDispatcher.new
      new_trip = trip_dispatcher.request_trip(passenger_id)

      new_trip.passenger.new_trip(new_trip)
      new_trip.passenger.trips.must_include new_trip

      new_trip.driver.new_trip(new_trip)
      new_trip.driver.trips.must_include new_trip
    end

    it "returns the status of chosen driver" do
      passenger_id = 10
      trip_dispatcher = RideShare::TripDispatcher.new
      new_trip = trip_dispatcher.request_trip(passenger_id)

      new_trip.driver.status.must_equal :AVAILABLE
    end

    it "can return the first driver who is available" do
      first_available_driver = "Emory Rosenbaum"
      second_available_driver = "Daryl Nitzsche"

      passenger_id = 10
      passenger_id_2 = 12
      trip_dispatcher =  RideShare::TripDispatcher.new

      new_trip_1 = trip_dispatcher.request_trip(passenger_id)
      new_trip_1.driver.new_trip(new_trip_1)

      new_trip_2 = trip_dispatcher.request_trip(passenger_id)

      new_trip_1.driver.name.must_equal first_available_driver

      new_trip_2.driver.name.must_equal second_available_driver

    end
  end


end
