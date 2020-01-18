require 'spec_helper'
require_relative '../../lib/parking_lot'

RSpec.describe AutomatedTicketingSystem::ParkingLot do
  describe :initialize do
    context 'given valid arguments' do
      it 'instantiates and return ParkingLot instance' do
        num_of_slots = 3
        parking_lot = AutomatedTicketingSystem::ParkingLot.new("#{num_of_slots}")
        expect(parking_lot.slots.length).to eql(num_of_slots)
        expect(parking_lot.slots.first.id).to eql(1)
      end
    end

    context 'given invalid arguments' do
      it 'raise an error' do
        expect { AutomatedTicketingSystem::ParkingLot.new(nil) }
            .to raise_error(ArgumentError)
        expect { AutomatedTicketingSystem::ParkingLot.new('nope') }
            .to raise_error(ArgumentError)
        expect { AutomatedTicketingSystem::ParkingLot.new('0') }
            .to raise_error(ArgumentError)
        expect { AutomatedTicketingSystem::ParkingLot.new('-3') }
            .to raise_error(ArgumentError)
      end
    end
  end

end