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

  describe :park do
    before(:each) do
      num_of_slots = 3
      @parking_lot = AutomatedTicketingSystem::ParkingLot.new("#{num_of_slots}")
    end

    context 'given valid arguments and available capacity' do
      veh_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      veh_colour = ['White', 'Black', 'White']

      it 'parks the car in the slot nearest to entry' do
        @parking_lot.park(veh_reg_num.first, veh_colour.first)
        expect(@parking_lot.slots.first.car.reg_num).to eql(veh_reg_num.first)
        expect(@parking_lot.slots.first.car.colour).to eql(veh_colour.first)
      end

      it 'parks multiple cars' do
        (0..2).each do |veh_idx|
          @parking_lot.park(veh_reg_num[veh_idx], veh_colour[veh_idx])
          expect(@parking_lot.slots[veh_idx].car.reg_num).to eql(veh_reg_num[veh_idx])
          expect(@parking_lot.slots[veh_idx].car.colour).to eql(veh_colour[veh_idx])
        end
      end

      it 'parks a car in the nearest free slot after a car leaves' do
        (0..2).each do |veh_idx|
          @parking_lot.park(veh_reg_num[veh_idx], veh_colour[veh_idx])
        end
        @parking_lot.leave('1')
        @parking_lot.park('NEW-REG-NUM', 'New Colour')
        expect(@parking_lot.slots[0].car.reg_num).to eql('NEW-REG-NUM')
        expect(@parking_lot.slots[0].car.colour).to eql('New Colour')
      end
    end

    context 'given valid arguments but unavailable capacity' do
      veh_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      veh_colour = ['White', 'Black', 'White']

      it 'fails to park the car' do
        (0..2).each do |veh_idx|
          @parking_lot.park(veh_reg_num[veh_idx], veh_colour[veh_idx])
        end
        expect { @parking_lot.park('NEW-REG-NUM', 'New Colour') }
            .to output("Sorry, parking lot is full\n").to_stdout
      end
    end
  end
end