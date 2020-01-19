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
      car_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      car_colour = ['White', 'Black', 'White']

      it 'parks the car in the slot nearest to entry' do
        @parking_lot.park(car_reg_num.first, car_colour.first)
        expect(@parking_lot.slots.first.car.reg_num).to eql(car_reg_num.first)
        expect(@parking_lot.slots.first.car.colour).to eql(car_colour.first)
      end

      it 'parks multiple cars' do
        (0..2).each do |car_idx|
          @parking_lot.park(car_reg_num[car_idx], car_colour[car_idx])
          expect(@parking_lot.slots[car_idx].car.reg_num).to eql(car_reg_num[car_idx])
          expect(@parking_lot.slots[car_idx].car.colour).to eql(car_colour[car_idx])
        end
      end

      it 'parks a car in the nearest free slot after a car leaves' do
        (0..2).each do |car_idx|
          @parking_lot.park(car_reg_num[car_idx], car_colour[car_idx])
        end
        @parking_lot.leave('1')
        @parking_lot.park('NEW-REG-NUM', 'New Colour')
        expect(@parking_lot.slots[0].car.reg_num).to eql('NEW-REG-NUM')
        expect(@parking_lot.slots[0].car.colour).to eql('New Colour')
      end
    end

    context 'given valid arguments but unavailable capacity' do
      car_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      car_colour = ['White', 'Black', 'White']

      it 'fails to park the car' do
        (0..2).each do |car_idx|
          @parking_lot.park(car_reg_num[car_idx], car_colour[car_idx])
        end
        expect { @parking_lot.park('NEW-REG-NUM', 'New Colour') }
            .to output("Sorry, parking lot is full\n").to_stdout
      end
    end
  end

  describe :leave do
    before(:each) do
      num_of_slots = 3
      @parking_lot = AutomatedTicketingSystem::ParkingLot.new("#{num_of_slots}")
    end

    context 'given valid slot number' do
      car_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      car_colour = ['White', 'Black', 'White']

      it 'unparks the car in the given slot' do
        @parking_lot.park(car_reg_num.first, car_colour.first)
        @parking_lot.leave('1')
        expect(@parking_lot.slots.first.car.nil?).to be true
      end
    end

    context 'given slot number out of range' do
      car_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      car_colour = ['White', 'Black', 'White']

      it 'fails to unpark car from given slot' do
        expect { @parking_lot.leave('999') }
            .to output("Invalid slot number\n").to_stdout

        @parking_lot.park(car_reg_num.first, car_colour.first)
        expect { @parking_lot.leave('999') }
            .to output("Invalid slot number\n").to_stdout
      end
    end

    context 'given invalid slot number' do
      it 'fails to unpark car from given slot' do
        expect { @parking_lot.leave('-1') }
            .to output("Invalid slot number\n").to_stdout

        expect { @parking_lot.leave('please') }
            .to output("Invalid slot number\n").to_stdout
      end
    end
  end

  describe :status do
    before(:each) do
      num_of_slots = 3
      @parking_lot = AutomatedTicketingSystem::ParkingLot.new("#{num_of_slots}")
    end

    context 'with no cars parked' do
      it 'displays correct status' do
        expect(@parking_lot.status).to output(<<-EOTXT
Slot No.    Registration No    Colour
                                       EOTXT
                                       ).to_stdout
      end
    end

    context 'after parking cars' do
      car_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      car_colour = ['White', 'Black', 'White']

      it 'displays correct status' do
        (0..2).each do |car_idx|
          @parking_lot.park(car_reg_num[car_idx], car_colour[car_idx])
        end
        expect(@parking_lot.status).to output(<<-EOTXT
Slot No.    Registration No    Colour
1           REG-NUM            White
2           REG-NUM-2          Black
3           REG-NUM-3          White
                                       EOTXT
                                       ).to_stdout
      end
    end

    context 'after parking and unparking cars' do
      car_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      car_colour = ['White', 'Black', 'White']

      it 'displays correct status' do
        (0..2).each do |car_idx|
          @parking_lot.park(car_reg_num[car_idx], car_colour[car_idx])
        end
        @parking_lot.leave('1')
        expect(@parking_lot.status).to output(<<-EOTXT
Slot No.    Registration No    Colour
2           REG-NUM-2          Black
3           REG-NUM-3          White
                                       EOTXT
                                       ).to_stdout
      end
    end
  end

  describe :registration_numbers_for_cars_with_colour do
    before(:each) do
      num_of_slots = 3
      @parking_lot = AutomatedTicketingSystem::ParkingLot.new("#{num_of_slots}")

      car_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      car_colour = ['White', 'Black', 'White']
      (0..2).each do |car_idx|
        @parking_lot.park(car_reg_num[car_idx], car_colour[car_idx])
      end
    end

    context 'given colour that matches parked cars' do
      it 'displays correct registration numbers' do
        expect(@parking_lot.registration_numbers_for_cars_with_colour('White'))
            .to output("REG-NUM, REG-NUM-3\n").to_stdout
        expect(@parking_lot.registration_numbers_for_cars_with_colour('Black'))
            .to output("REG-NUM-2\n").to_stdout
      end
    end

    context 'given colour that doesn\' match any parked cars' do
      it 'displays "Not found" message' do
        expect(@parking_lot.registration_numbers_for_cars_with_colour('Indigo'))
            .to output("Not found\n").to_stdout
      end
    end

    context 'given colour that matched a car that has unparked' do
      it 'displays correct registration numbers' do
        @parking_lot.leave('1')
        expect(@parking_lot.registration_numbers_for_cars_with_colour('White'))
            .to output("REG-NUM-3\n").to_stdout
        expect(@parking_lot.registration_numbers_for_cars_with_colour('Black'))
            .to output("REG-NUM-2\n").to_stdout
      end
    end
  end

  describe :slot_numbers_for_cars_with_colour do
    before(:each) do
      num_of_slots = 3
      @parking_lot = AutomatedTicketingSystem::ParkingLot.new("#{num_of_slots}")

      car_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      car_colour = ['White', 'Black', 'White']
      (0..2).each do |car_idx|
        @parking_lot.park(car_reg_num[car_idx], car_colour[car_idx])
      end
    end

    context 'given colour that matches parked cars' do
      it 'displays correct slot numbers' do
        expect(@parking_lot.slot_numbers_for_cars_with_colour('White'))
            .to output("1, 3\n").to_stdout
        expect(@parking_lot.slot_numbers_for_cars_with_colour('Black'))
            .to output("2\n").to_stdout
      end
    end

    context 'given colour that doesn\' match any parked cars' do
      it 'displays "Not found" message' do
        expect(@parking_lot.slot_numbers_for_cars_with_colour('Indigo'))
            .to output("Not found\n").to_stdout
      end
    end

    context 'given colour that matched a car that has unparked' do
      it 'displays correct slot numbers' do
        @parking_lot.leave('1')
        expect(@parking_lot.slot_numbers_for_cars_with_colour('White'))
            .to output("3\n").to_stdout
        expect(@parking_lot.slot_numbers_for_cars_with_colour('Black'))
            .to output("2\n").to_stdout
      end
    end
  end

  describe :slot_number_for_registration_number do
    before(:each) do
      num_of_slots = 3
      @parking_lot = AutomatedTicketingSystem::ParkingLot.new("#{num_of_slots}")
    end

    context 'given registration number that matches parked cars' do
      car_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      car_colour = ['White', 'Black', 'White']

      it 'displays correct slot numbers' do
        (0..2).each do |car_idx|
          @parking_lot.park(car_reg_num[car_idx], car_colour[car_idx])
          expect(@parking_lot.slot_number_for_registration_number(car_reg_num[car_idx]))
              .to output(car_idx + 1).to_stdout
        end
      end
    end

    context 'given registration number that doesn\' match any parked cars' do
      it 'displays "Not found" message' do
        expect(@parking_lot.slot_number_for_registration_number('NOT-HE-RE-111'))
            .to output("Not found\n").to_stdout
      end
    end

    context 'given registration number that matched a car that has unparked' do
      car_reg_num = ['REG-NUM', 'REG-NUM-2', 'REG-NUM-3']
      car_colour = ['White', 'Black', 'White']

      it 'displays correct slot numbers' do
        (0..2).each do |car_idx|
          @parking_lot.park(car_reg_num[car_idx], car_colour[car_idx])
        end

        @parking_lot.leave('1')
        expect(@parking_lot.slot_number_for_registration_number('REG-NUM'))
            .to output("Not found\n").to_stdout
        expect(@parking_lot.slot_number_for_registration_number('REG-NUM-2'))
            .to output("2\n").to_stdout
        expect(@parking_lot.slot_number_for_registration_number('REG-NUM-3'))
            .to output("3\n").to_stdout
      end
    end
  end
end