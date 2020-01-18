require 'spec_helper'

RSpec.describe 'Command Line Functions' do
  let(:pty) { PTY.spawn('parking_lot') }

  before(:each) do |test|
    run_command(pty, "create_parking_lot 3\n") unless test.metadata[:skip_parking_lot_init]
  end

  it "should fail to create a parking lot with invalid slot number", :skip_parking_lot_init do
    run_command(pty, "create_parking_lot -3\n")
    expect(fetch_stdout(pty)).to end_with("Invalid number of slots\n")

    run_command(pty, "create_parking_lot please\n")
    expect(fetch_stdout(pty)).to end_with("Invalid number of slots\n")
  end

  it "can create a parking lot", :sample => true do
    expect(fetch_stdout(pty)).to end_with("Created a parking lot with 3 slots\n")
  end

  it "should fail to create a parking lot if it already exists" do
    run_command(pty, "create_parking_lot 4\n")
    expect(fetch_stdout(pty)).to end_with("Parking lot already exists\n")
  end

  it "can park a car in an available slot" do
    run_command(pty, "park KA-01-HH-3141 Black\n")
    expect(fetch_stdout(pty)).to end_with("Allocated slot number: 1\n")
  end

  it "can reject parking a car if parking lot is full" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "park KA-01-HH-9999 White\n")
    run_command(pty, "park KA-01-BB-0001 Black\n")

    expect(fetch_stdout(pty)).to end_with("Sorry, parking lot is full\n")
  end

  it "can unpark a car from an occupied slot" do
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "leave 1\n")
    expect(fetch_stdout(pty)).to end_with("Slot number 1 is free\n")
  end

  it "can properly fail to unpark a car from an empty slot" do
    run_command(pty, "leave 1\n")
    expect(fetch_stdout(pty)).to end_with("No car in slot number 1\n")
  end

  it "can properly fail to unpark a car from an invalid slot number" do
    run_command(pty, "leave -1\n")
    expect(fetch_stdout(pty)).to end_with("Invalid slot number\n")

    run_command(pty, "leave please\n")
    expect(fetch_stdout(pty)).to end_with("Invalid slot number\n")
  end

  it "can report status" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "park KA-01-HH-9999 White\n")
    run_command(pty, "status\n")
    expect(fetch_stdout(pty)).to end_with(<<-EOTXT
Slot No.    Registration No    Colour
1           KA-01-HH-1234      White
2           KA-01-HH-3141      Black
3           KA-01-HH-9999      White
EOTXT
)
  end

  it "can find registration numbers of all cars of a particular colour" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "park KA-01-HH-9999 White\n")
    run_command(pty, "registration_numbers_for_cars_with_colour White\n")
    expect(fetch_stdout(pty)).to end_with("KA-01-HH-1234, KA-01-HH-9999\n")
  end

  it "can properly fail to find registration numbers of all cars of a particular colour" do
    run_command(pty, "registration_numbers_for_cars_with_colour White\n")
    expect(fetch_stdout(pty)).to end_with("Not found\n")

    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "registration_numbers_for_cars_with_colour White\n")
    expect(fetch_stdout(pty)).to end_with("Not found\n")
  end

  it "can find slot numbers for cars with colour" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "slot_numbers_for_cars_with_colour White\n")
    expect(fetch_stdout(pty)).to end_with("1\n")

    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "park KA-01-HH-9999 White\n")
    run_command(pty, "slot_numbers_for_cars_with_colour White\n")
    expect(fetch_stdout(pty)).to end_with("1, 3\n")

    run_command(pty, "leave 1\n")
    expect(fetch_stdout(pty)).to end_with("3\n")
  end

  it "can properly fail to find slot numbers for cars with colour" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "slot_numbers_for_cars_with_colour Black\n")
    expect(fetch_stdout(pty)).to end_with("Not found\n")

    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "leave 2\n")
    expect(fetch_stdout(pty)).to end_with("Not found\n")
  end

  it "can find slot number in which a car with a given registration number is parked" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "slot_number_for_registration_number KA-01-HH-1234\n")
    expect(fetch_stdout(pty)).to end_with("1\n")

    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "park KA-01-HH-9999 White\n")
    run_command(pty, "slot_number_for_registration_number KA-01-HH-1234\n")
    expect(fetch_stdout(pty)).to end_with("1\n")
    run_command(pty, "slot_number_for_registration_number KA-01-HH-3141\n")
    expect(fetch_stdout(pty)).to end_with("2\n")
    run_command(pty, "slot_number_for_registration_number KA-01-HH-9999\n")
    expect(fetch_stdout(pty)).to end_with("3\n")
  end

  it "can properly fail to find slot number in which a car with a given registration number is parked" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "slot_number_for_registration_number NOT-HE-RE-111\n")
    expect(fetch_stdout(pty)).to end_with("Not found\n")

    run_command(pty, "leave 1\n")
    run_command(pty, "slot_number_for_registration_number KA-01-HH-1234\n")
    expect(fetch_stdout(pty)).to end_with("Not found\n")
  end
end
