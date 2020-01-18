require 'spec_helper'

RSpec.describe 'Parking Lot' do
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
  
  it "can unpark a car" do
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "leave 1\n")
    expect(fetch_stdout(pty)).to end_with("Slot number 1 is free\n")
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
  
  pending "add more specs as needed"
end
